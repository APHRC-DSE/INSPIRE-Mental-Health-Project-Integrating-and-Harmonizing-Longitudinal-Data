library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

## Condition Occurrence CDM table Transformation

condition_occurrence_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  ## Individual demographics
  condition_table_a <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id) %>%
    dplyr::distinct() %>%
    dplyr::inner_join(person_cdm_table[[nn]] %>%
                        dplyr::select(person_id, location_id, provider_id, care_site_id),
                      by = c("individual_id" = "person_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        dplyr::select(individual_id, household_id),
                      by = c("individual_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["individual_demographics"]] %>%
                        dplyr::mutate(individual_concept_id_text = trimws(individual_concept_id_text)
                                      ) %>%
                        dplyr::filter(individual_concept_id_text %in% c("Diabetes present", "Mild anemia", "Severe anemia", "No anemia present",
                                                                        "Moderate anemia", "Dyslipidemia", "Hypertension", "No pain",
                                                                        "Normal Blood Pressure", "Diabetes", "Pain", "HIV Negative",
                                                                        "Acquired immunodeficiency syndrome, AIDS, or HIV positive"
                                                                        )
                                      ),
                      by = c("individual_id")
                      ) %>%
    dplyr::mutate(individual_concept_id = ifelse(individual_concept_id_text %in% c("Hypertension"), 316866,
                                          ifelse(individual_concept_id_text %in% c("No pain"), 4116815,
                                          ifelse(individual_concept_id_text %in% c("Diabetes"), 201820,
                                          ifelse(individual_concept_id_text %in% c("Acquired immunodeficiency syndrome, AIDS, or HIV positive"), 4267414,
                                          ifelse(individual_concept_id_text %in% c("HIV Negative"), 4013105,
                                          ifelse(individual_concept_id_text %in% c("No anemia present"), 4094766,
                                          ifelse(individual_concept_id_text %in% c("Mild anemia","Severe anemia", "Moderate anemia"), 439777,
                                                 as.numeric(individual_concept_id))))))))
                  ) %>%
    #Group conditions with more than one level so as to obtain wave_id
    dplyr::mutate(condition_concept_text = ifelse(individual_concept_id_text %in% c("Acquired immunodeficiency syndrome, AIDS, or HIV positive",
                                                                                       "HIV Negative"
                                                                                    ), "HIV status", #HIV status
                                           ifelse(individual_concept_id_text %in% c("Hypertension", "Normal Blood Pressure"
                                                                                    ),"Blood pressure status", #Blood pressure status
                                           ifelse(individual_concept_id_text %in% c("Mild anemia","Severe anemia", "Moderate anemia",
                                                                                    "No anemia present"
                                                                                    ), "Anemia status", #Anaemia status
                                           ifelse(individual_concept_id_text %in% c("Pain","No pain"
                                                                                    ), "Pain status", #Pain
                                                  individual_concept_id_text
                                                  ))))
                    ) %>%
    dplyr::arrange(condition_concept_text) %>%
    dplyr::group_by(individual_id, condition_concept_text) %>%
    dplyr::mutate(unique_seq = dplyr::row_number()
                  ,unique_types = dplyr::n_distinct(individual_concept_id) 
                  ) %>%
    dplyr::ungroup() %>%
    dplyr::inner_join(staging_tables_data[["wave"]] %>%
                        dplyr::select(wave_id, name, population_study_id) %>%
                        dplyr::mutate(name = readr::parse_number(name))
                      , by = c("population_study_id" = "population_study_id", "unique_seq" = "name")
                        ) %>%
    dplyr::mutate(wave_id = ifelse(population_study_id %in% c(12) & wave_id ==33, 1,
                            ifelse(population_study_id %in% c(12) & wave_id ==34, 2,
                            ifelse(population_study_id %in% c(14) & wave_id ==36, 1, wave_id
                                   )))
                  #Matching wave_id for study 12,14 as is in staging. Transformed wrongly
                  ) %>%
    #Get interview date from wave id
    dplyr::inner_join(staging_tables_data[["interview"]] %>%
                        dplyr::select(individual_id, interview_date, wave_id) %>%
                        dplyr::distinct(),
                      by = c("individual_id","wave_id")
                      ) %>%
    #interview_date not linked with visit_start_date to duplicate entries for studies that had only one set of demographics for multiple waves
    dplyr::inner_join(visit_occurrence_cdm_table[[nn]] %>%
                        dplyr::select(person_id, visit_occurrence_id, visit_start_date, visit_start_datetime, provider_id, care_site_id),
                      by = c("individual_id" = "person_id"
                             , "provider_id" = "provider_id"
                             , "care_site_id" = "care_site_id"
                             )
                      ) %>%
    dplyr::mutate(visit_start_date = if_else(unique_types == 2 & interview_date != visit_start_date, NA, visit_start_date)
                  #Condition to remove duplicate values so as to remain with changing conditions
                  ) %>%
    tidyr::drop_na(visit_start_date) %>%
    dplyr::select(-c(unique_seq, unique_types, interview_date, wave_id)
                  ) %>%
    dplyr::inner_join(visit_detail_cdm_table[[nn]] %>%
                         dplyr::select(person_id, visit_detail_id, visit_detail_start_date, provider_id, care_site_id, visit_occurrence_id),
                       by = c("individual_id" = "person_id"
                              , "provider_id" = "provider_id"
                              , "care_site_id" = "care_site_id"
                              , "visit_occurrence_id" = "visit_occurrence_id"
                              , "visit_start_date" = "visit_detail_start_date"
                              )
                       ) %>%
    dplyr::distinct(visit_occurrence_id, individual_concept_id_text, .keep_all = TRUE) %>%
    #Remerge interview table to get actual wave again
    dplyr::inner_join(staging_tables_data[["interview"]] %>%
                        dplyr::select(individual_id, interview_date, wave_id) %>%
                        dplyr::distinct(),
                      by = c("individual_id" = "individual_id", "visit_start_date" = "interview_date")
                      ) %>%
    dplyr::mutate(condition_concept_id = individual_concept_id) %>%
    dplyr::rename( person_id = individual_id
                   , condition_start_date = visit_start_date
                   , condition_start_datetime = visit_start_datetime
                   , condition_source_value = individual_concept_id_text
                   , condition_source_concept_id = individual_concept_id
                   )
  
  ## LPS fact table tool scores
  condition_table_b <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::arrange(fact_id) %>%
    dplyr::select(population_study_id, individual_id, interview_id, instrument_id, instrument_item_id, concept_id,
                  value_type_concept_id, value_as_char, value_as_num
                  ) %>%
    dplyr::mutate(instrument_item_id = ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 110, 121,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 111, 122,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 112, 123,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 113, 124,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 114, 125,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 115, 126,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 116, 127,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 117, 128,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 118, 129,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 119, 130,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 120, 131,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 121, 132,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 122, 133,
                                       ifelse(instrument_id == 15 & population_study_id == 5 & instrument_item_id == 123, 134,
                                              as.numeric(instrument_item_id)
                                              )))))))))))))) #update instrument_item_id for instrument 15 as per new instrument_item metadata
                  , value_type_concept_id = ifelse(instrument_id == 7 & population_study_id == 12 & 
                                                     concept_id %in% c(3000000165, 3000000166, 3000000167), as.numeric(concept_id),
                                                   as.numeric(value_type_concept_id)
                                                   ) #population study 12 concept id for questions in wrong column
                  , concept_id = ifelse(instrument_id == 7 & population_study_id == 12 & 
                                          concept_id %in% c(3000000165, 3000000166, 3000000167), NA,
                                        as.numeric(concept_id)
                                        ) #population study 12, NA represents no answers to questions
                  , concept_id = ifelse(instrument_id == 6 & population_study_id %in% c(6, 7, 8, 9, 10, 11) &
                                          value_type_concept_id == 1761347 , as.numeric(value_type_concept_id),
                                        as.numeric(concept_id)
                                        ) #population study 6,7,8,9,10,11 tool total scores conceptid in value_type_concept_id
                  , value_type_concept_id = ifelse(instrument_id == 6 & population_study_id %in% c(6, 7, 8, 9, 10, 11) &
                                                     value_type_concept_id == 1761347 , NA,
                                                   as.numeric(value_type_concept_id)
                                                   ) #population study 6,7,8,9,10,11 NA represents no concept id as per staging db
                  , concept_id = ifelse(instrument_id == 2 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Over half the days", 45878994,
                                 ifelse(instrument_id == 2 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Not at all sure", 45883172,
                                 ifelse(instrument_id == 16 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "No", 4188540,
                                 ifelse(instrument_id == 16 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Yes", 4188539,
                                        as.numeric(concept_id) 
                                        )))) #population study 14 conceptid for GAD7 and PSQ answers from NA to actual
                  ) %>%
    dplyr::inner_join(staging_tables_data[["interview"]] %>%
                        dplyr::select(individual_id, interview_id, interview_date, instrument_id, wave_id),
                      by = c("interview_id", "individual_id", "instrument_id")
                      ) %>%
    dplyr::inner_join(visit_detail_cdm_table[[nn]] %>%
                        dplyr::select(visit_detail_id, visit_occurrence_id, person_id, visit_detail_start_date,
                                      visit_detail_start_datetime, provider_id, visit_detail_source_concept_id) %>%
                        dplyr::mutate(instrument_id = ifelse(visit_detail_source_concept_id == 44804610, 1,
                                                      ifelse(visit_detail_source_concept_id == 45772733, 2,
                                                      ifelse(visit_detail_source_concept_id == 3000000219, 3,
                                                      ifelse(visit_detail_source_concept_id == 4164838, 4, 
                                                      ifelse(visit_detail_source_concept_id == 37310582, 5,
                                                      ifelse(visit_detail_source_concept_id == 1761569, 6,
                                                      ifelse(visit_detail_source_concept_id == 3000000223, 7,
                                                      ifelse(visit_detail_source_concept_id == 36714019, 8,
                                                      ifelse(visit_detail_source_concept_id == 1988691, 9,
                                                      ifelse(visit_detail_source_concept_id == 3000000226, 10,
                                                      ifelse(visit_detail_source_concept_id == 3000000227, 11,
                                                      ifelse(visit_detail_source_concept_id == 3000000228, 12,
                                                      ifelse(visit_detail_source_concept_id == 3000000229, 13,
                                                      ifelse(visit_detail_source_concept_id == 3000000230, 14,
                                                      ifelse(visit_detail_source_concept_id == 44783153, 15,
                                                      ifelse(visit_detail_source_concept_id == 3000000266, 16, 0
                                                             ))))))))))))))))
                                      , instrument_id = as.integer(instrument_id)
                                      )
                      , by = c("interview_date"= "visit_detail_start_date"
                               , "individual_id" = "person_id"
                               , "instrument_id" = "instrument_id"
                               )
                      ) %>%
    dplyr::filter(instrument_item_id %in% c(10, 18, 19, 20, 21, 32, 53, 74, 109, 110
                                            , 111, 112, 118, 134, 135) #Filter Total scores only
                  ) %>%
    dplyr::left_join(staging_tables_data[["instrument"]] %>%
                        dplyr::select(instrument_id, name),
                      by = c("instrument_id")
                      ) %>%
    dplyr::mutate( instrument_item_id = as.numeric(instrument_item_id)
                   , value_as_num = as.numeric(value_as_num)
                   , condition = if_else(instrument_item_id == 10 & value_as_num < 5 , "No depression", #PHQ-9
                                 if_else(instrument_item_id == 10 & value_as_num < 10 , "Mild depression", #PHQ-9
                                 if_else(instrument_item_id == 10 & value_as_num < 15 , "Moderate depression", #PHQ-9
                                 if_else(instrument_item_id == 10 & value_as_num < 20 , "Moderate Severe depression", #PHQ-9
                                 if_else(instrument_item_id == 10 & value_as_num >19 , "Severe depression", #PHQ-9
                                 if_else(instrument_item_id == 18 & value_as_num < 5 , "No anxiety", #GAD-7
                                 if_else(instrument_item_id == 18 & value_as_num < 10 , "Mild anxiety", #GAD-7
                                 if_else(instrument_item_id == 18 & value_as_num < 15 , "Moderate anxiety", #GAD-7
                                 if_else(instrument_item_id == 18 & value_as_num >14 , "Severe anxiety", #GAD-7
                                 if_else(instrument_item_id == 32 & wave_id == 1 & value_as_num <10 , "No antenatal depression", #EPDS
                                 if_else(instrument_item_id == 32 & wave_id == 2 & value_as_num <10 , "No postpartum depression", #EPDS
                                 if_else(instrument_item_id == 32 & wave_id == 1 & value_as_num >9 , "Antenatal depression", #EPDS
                                 if_else(instrument_item_id == 32 & wave_id == 2 & value_as_num >9 , "Pospartum depression", #EPDS
                                 if_else(instrument_item_id == 74 & wave_id %in% c(9, 11) & value_as_num <3 , "No depression", #CES-D8 binary response
                                 if_else(instrument_item_id == 74 & wave_id %in% c(9, 11) & value_as_num >2 , "Depression", #CES-D8 binary response
                                 if_else(instrument_item_id == 74 & wave_id %in% c(12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                                                                                   27, 28, 29, 30, 31, 32)
                                         & value_as_num <10 , "No depression", #CES-D-10
                                 if_else(instrument_item_id == 74 & wave_id %in% c(12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                                                                                   27, 28, 29, 30, 31, 32) 
                                         & value_as_num >9 , "Depression", #CES-D-10
                                 if_else(instrument_item_id == 74 & wave_id %in% c(10) & value_as_num <16 , "No depression", #CES-D20 
                                 if_else(instrument_item_id == 74 & wave_id %in% c(10) & value_as_num >15 , "Depression", #CES-D20 
                                 if_else(instrument_item_id == 53 & wave_id %in% c(9, 11) & value_as_num <4 , "No PTSD", #PCL-5 short form
                                 if_else(instrument_item_id == 53 & wave_id %in% c(9, 11) & value_as_num >3 , "PTSD",   #PCL-5 short form
                                 if_else(instrument_item_id == 53 & wave_id %in% c(3, 4, 5, 6, 7, 8) & value_as_num <31 , "No PTSD", #PCL-5
                                 if_else(instrument_item_id == 53 & wave_id %in% c(3, 4, 5, 6, 7, 8) & value_as_num >30 , "PTSD", #PCL-5
                                 if_else(instrument_item_id == 134 & value_as_num <5 , "Good sleep hygiene", #PSQI
                                 if_else(instrument_item_id == 134 & value_as_num >4 , "Poor sleep hygiene",   #PSQI
                                 if_else(instrument_item_id == 109 & value_as_num <3 , "No Psychosis", #PSQ
                                 if_else(instrument_item_id == 109 & value_as_num >2 , "Psychosis",   #PSQ
                                 if_else(instrument_item_id == 21 & value_as_num <10 , "No Depression", #DASS-21 Depression
                                 if_else(instrument_item_id == 21 & value_as_num >9 , "Depression",  #DASS-21 Depression    
                                 if_else(instrument_item_id == 19 & value_as_num <8 , "No Anxiety", #DASS-21 Anxiety
                                 if_else(instrument_item_id == 19 & value_as_num >7 , "Anxiety",  #DASS-21 Anxiety        
                                 if_else(instrument_item_id == 20 & value_as_num <15 , "No PTSD", #DASS-21 Stress
                                 if_else(instrument_item_id == 20 & value_as_num >14 , "PTSD", NA #DASS-21 Stress
                                         
                                         )))))))))))))))))))))))))))))))))
                   , condition_concept_id = if_else(condition=="Depression", 440383,
                                            if_else(condition=="Antenatal depression", 37312479,
                                            if_else(condition=="Pospartum depression", 4239471,
                                            if_else(condition=="PTSD", 436676,
                                            if_else(condition=="Poor sleep hygiene", 3327871, #40481897,
                                            if_else(condition=="Psychosis", 436073,
                                            if_else(condition=="Anxiety", 442077,
                                            if_else(condition=="Severe anxiety", 442077, #4214746,
                                            if_else(condition=="Moderate anxiety", 442077, #4263429,
                                            if_else(condition=="Mild anxiety", 0, #4322025,
                                            if_else(condition=="Severe depression", 440383, #4149321,
                                            if_else(condition=="Moderate Severe depression", 440383, #36717092,
                                            if_else(condition=="Moderate depression", 440383, #4151170,
                                            if_else(condition=="Mild depression", 0, #4149320,
                                                    0
                                                    
                                                    ))))))))))))))
                   
                   ) %>%
    tidyr::drop_na(condition) %>%
    dplyr::filter(condition_concept_id !=0
                  ) %>%
    dplyr::mutate(value_as_num = as.character(value_as_num)
                  ) %>%
    dplyr::rename( person_id = individual_id
                   , condition_start_date = interview_date
                   , condition_start_datetime = visit_detail_start_datetime
                   , condition_source_value = value_as_num
                   , condition_status_source_value = name
                   , condition_source_concept_id = concept_id
                   )
  
  condition_table_final <- dplyr::bind_rows(condition_table_a, condition_table_b) %>%
    dplyr::arrange(person_id, visit_occurrence_id, visit_detail_id) %>%
    dplyr::mutate( condition_occurrence_id = 1:n()
                   , condition_end_date = NA
                   , condition_type_concept_id = 32883
                   , condition_status_concept_id = 32899
                   , condition_end_datetime = NA
                   , stop_reason = NA
                   ) %>%
    dplyr::select( condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_start_datetime,
                   condition_end_date, condition_end_datetime, condition_type_concept_id, condition_status_concept_id,
                   stop_reason, provider_id, visit_occurrence_id, visit_detail_id, condition_source_value,
                   condition_source_concept_id, condition_status_source_value
                   ) %>%
    dplyr::mutate(across(c(condition_status_source_value, condition_source_value), ~strtrim(.x, 49)
                         )
                  )
  
}, simplify = FALSE
)


## Loading to CDM tables

condition_occurrence_cdm_load <- sapply(names(condition_occurrence_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "condition_occurrence"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = condition_occurrence_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(condition_occurrence_id="integer", person_id= "integer", condition_concept_id="integer",
                                        condition_start_date="date", condition_start_datetime="timestamp without time zone",
                                        condition_end_date="date", condition_end_datetime="timestamp without time zone",
                                        condition_type_concept_id="integer", condition_status_concept_id="integer",
                                        stop_reason="character varying (20)", provider_id="integer", visit_occurrence_id="integer",
                                        visit_detail_id="integer", condition_source_value="character varying (50)",
                                        condition_source_concept_id="bigint", condition_status_source_value="character varying (50)"
                                        )
                      )
    
    #to accomodate inspire concepts condition_source_concept_id="bigint" supposed to be condition_source_concept_id="integer"
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.condition_occurrence ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY (condition_occurrence_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
