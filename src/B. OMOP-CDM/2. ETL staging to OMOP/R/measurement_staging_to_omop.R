library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

## Measurement CDM table Transformation

measurement_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  measurement_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
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
                  , concept_id = ifelse(instrument_id %in% c(1, 2, 16) & population_study_id %in% c(13) &
                                          value_type_concept_id %in% c(3042932, 42868746, 3000000278) , as.numeric(value_type_concept_id),
                                        as.numeric(concept_id)
                                        ) #population study 13 tool total scores conceptid in value_type_concept_id
                  , value_type_concept_id = ifelse(instrument_id == 6 & population_study_id %in% c(6, 7, 8, 9, 10, 11) &
                                                     value_type_concept_id == 1761347 , NA,
                                                   as.numeric(value_type_concept_id)
                                                   ) #population study 6,7,8,9,10,11 NA represents no concept id as per staging db
                  , value_type_concept_id = ifelse(instrument_id %in% c(1, 2, 16) & population_study_id %in% c(13) &
                                                     value_type_concept_id %in% c(3042932, 42868746, 3000000278) , NA,
                                                   as.numeric(value_type_concept_id)
                                                   ) #population study 13 NA represents no concept id as per staging db
                  , concept_id = ifelse(instrument_id == 2 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Over half the days", 45878994,
                                 ifelse(instrument_id == 2 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Not at all sure", 45883172,
                                 ifelse(instrument_id == 16 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "No", 4188540,
                                 ifelse(instrument_id == 16 & population_study_id ==14 & is.na(concept_id) &
                                          value_as_char == "Yes", 4188539,
                                        as.numeric(concept_id) 
                                        )))) #population study 14 conceptid for GAD7 and PSQ answers NA to actual
                  , concept_id = ifelse(population_study_id %in% c(4,5) & concept_id == 3000000561, 4188540,
                                 ifelse(population_study_id %in% c(4,5) & concept_id == 3000000560, 4188539,
                                        as.numeric(concept_id) 
                                        )) #population study 4 & 5 conceptid 3000000561/3000000560 to 4188539/4188540
                  ) %>%
    dplyr::inner_join(staging_tables_data[["interview"]] %>%
                        dplyr::select(individual_id, interview_id, interview_date, instrument_id),
                      by = c("interview_id", "individual_id", "instrument_id")
                      ) %>%
    dplyr::inner_join(visit_detail_cdm_table[[nn]] %>%
                        dplyr::select(visit_detail_id, visit_occurrence_id, person_id, visit_detail_start_date,
                                      visit_detail_start_datetime, provider_id, visit_detail_source_concept_id) %>%
                        dplyr::mutate(instrument_id = ifelse(visit_detail_source_concept_id == 44804610, 1,
                                                      ifelse(visit_detail_source_concept_id == 45772733, 2,
                                                      ifelse(visit_detail_source_concept_id == 2000000219, 3,
                                                      ifelse(visit_detail_source_concept_id == 4164838, 4, 
                                                      ifelse(visit_detail_source_concept_id == 37310582, 5,
                                                      ifelse(visit_detail_source_concept_id == 1761569, 6,
                                                      ifelse(visit_detail_source_concept_id == 2000000223, 7,
                                                      ifelse(visit_detail_source_concept_id == 36714019, 8,
                                                      ifelse(visit_detail_source_concept_id == 1988691, 9,
                                                      ifelse(visit_detail_source_concept_id == 2000000226, 10,
                                                      ifelse(visit_detail_source_concept_id == 2000000227, 11,
                                                      ifelse(visit_detail_source_concept_id == 2000000228, 12,
                                                      ifelse(visit_detail_source_concept_id == 2000000229, 13,
                                                      ifelse(visit_detail_source_concept_id == 2000000230, 14,
                                                      ifelse(visit_detail_source_concept_id == 44783153, 15,
                                                      ifelse(visit_detail_source_concept_id == 2000000266, 16, 0
                                                             ))))))))))))))))
                                      , instrument_id = as.integer(instrument_id)
                                      )
                      , by = c("interview_date"= "visit_detail_start_date"
                             , "individual_id" = "person_id"
                             , "instrument_id" = "instrument_id"
                             )
                      ) %>%
    
    dplyr::filter(!instrument_id %in% c(7) #Drop Basis 24 tool
                  ) %>%
    dplyr::mutate(measurement_id = 1:n()
                  , measurement_concept_id = as.numeric(visit_detail_source_concept_id)
                  , measurement_concept_id = ifelse(measurement_concept_id %in% c(1761569), 44788755, measurement_concept_id
                                                    ) #replacing observation domain concept_id for CES-D to one of measurement domain
                  #, measurement_concept_id = ifelse(measurement_concept_id %in% c(3000000266), 40486512, measurement_concept_id
                  #                                 ) #replacing observation domain concept_id for PSQ to one of measurement domain
                  , measurement_concept_id = ifelse(instrument_item_id %in% c(19, 20, 21), as.numeric(concept_id),
                                                    measurement_concept_id
                                                    ) #DASS21 instruments items with concepts in measurement domain
                  , value_as_concept_id = ifelse(instrument_item_id %in% c(10, 18, 19, 20, 21, 32, 53, 74, 109, 110
                                                                           , 111, 112, 118, 134, 135), 4112438,
                                                 as.numeric(concept_id)
                                                 ) #Total score of tools Generalized with Concept ID for Total( Meas value domain)
                  , measurement_time = "00:00:00"
                  , measurement_type_concept_id = 32883
                  , operator_concept_id = NA
                  , unit_concept_id = NA
                  , range_low = NA
                  , range_high = NA
                  , measurement_source_concept_id = ifelse(instrument_item_id %in% c(10, 18, 19, 20, 21, 32, 53, 74, 109, 110
                                                                                     , 111, 112, 118, 134, 135), as.numeric(concept_id),
                                                           as.numeric(value_type_concept_id)
                                                           ) #Concept ID for the tools total score
                  , unit_source_value = NA
                  , unit_source_concept_id = NA
                  , value_source_value = NA
                  , measurement_event_id = NA
                  , meas_event_field_concept_id = NA
                  ) %>%
    dplyr::left_join(staging_tables_data[["concept"]] %>%
                        dplyr::select(concept_text, concept_id) %>%
                        dplyr::distinct(concept_id, .keep_all = TRUE),
                      by = c("measurement_source_concept_id"="concept_id")
                      ) %>%
    dplyr::arrange(individual_id, visit_occurrence_id, visit_detail_id) %>%
    dplyr::rename( person_id = individual_id
                   , measurement_date = interview_date
                   , measurement_datetime = visit_detail_start_datetime
                   , value_as_number = value_as_num
                   , measurement_source_value = concept_text
                   #, value_source_value = value_as_char
                   ) %>%
    dplyr::select( measurement_id, person_id, measurement_concept_id, measurement_date, measurement_datetime
                   , measurement_time, measurement_type_concept_id, operator_concept_id, value_as_number, value_as_concept_id
                   , unit_concept_id, range_low, range_high, provider_id, visit_occurrence_id, visit_detail_id
                   , measurement_source_value, measurement_source_concept_id, unit_source_value, unit_source_concept_id
                   , value_source_value, measurement_event_id, meas_event_field_concept_id
                   ) %>%
    dplyr::mutate(across(c(measurement_source_value, value_source_value), ~strtrim(.x, 49)
                         )
                  , measurement_source_concept_id = if_else(measurement_source_concept_id > 3000000000,
                                                            measurement_source_concept_id - 1000000000,
                                                            measurement_source_concept_id
                                                            ) #change INSPIRE concepts to 2 billion
                  ) %>%
    dplyr::filter(value_as_concept_id == 4112438 #Only retain total scores and drop responses
                  ) %>%
    tidyr::drop_na(value_as_number) %>% #drop NA's in total score
    dplyr::mutate(measurement_id = 1:n()
                  )
    
  # population study 12 did not have total score row for the third tool BASIS-24
}, simplify = FALSE
)


## Loading to CDM tables

measurement_cdm_load <- sapply(names(measurement_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "measurement"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = measurement_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(measurement_id="integer", person_id="integer", measurement_concept_id="integer"
                                        , measurement_date="date", measurement_datetime="timestamp without time zone"
                                        , measurement_time="character varying (10)", measurement_type_concept_id="integer"
                                        , operator_concept_id="integer", value_as_number="numeric", value_as_concept_id="integer"
                                        , unit_concept_id="integer", range_low="numeric", range_high="numeric", provider_id="integer"
                                        , visit_occurrence_id="integer", visit_detail_id="integer", measurement_source_value="character varying (50)"
                                        , measurement_source_concept_id="integer", unit_source_value="character varying (50)"
                                        , unit_source_concept_id="integer", value_source_value="character varying (50)"
                                        , measurement_event_id="integer", meas_event_field_concept_id="integer"
                                        )
                      )
    
    #to accomodate inspire concepts measurement_concept_id="bigint" supposed to be measurement_concept_id="integer"
    #to accomodate inspire concepts measurement_source_concept_id="bigint" supposed to be measurement_source_concept_id="integer"
  
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.measurement ADD CONSTRAINT xpk_measurement PRIMARY KEY (measurement_id);
                                                          ")
                     )
  
}, simplify = FALSE
)

