library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

## Observation CDM table Transformation

observation_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  ## Individual demographics
  observation_table_a <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
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
                        dplyr::filter(!individual_concept_id_text %in% c("Coloured", "Asian/Indian", "African", "White", "Asian Indian",
                                                                         "Not Hispanic or Latino", "BMI", "No diabetes", "Diabetes",
                                                                         "Diabetes present", "Mild anemia", "Severe anemia",
                                                                         "Moderate anemia", "No anemia present", "Dyslipidemia",
                                                                         "No Dyslipidemia", "Hypertension", "Normal Blood Pressure",
                                                                         "Pain", "No pain", "HIV Negative",
                                                                         "Acquired immunodeficiency syndrome, AIDS, or HIV positive",
                                                                         "does not smoke smokeless tobacco", "Smokeless tobacco",
                                                                         "drinker", "Non - drinker", "drinks", "Not Hispanic or Latin"
                                                                         )
                                      ),
                      by = c("individual_id")
                      ) %>%
    #Group socio-demo into hierachy so as to obtain wave_id 
    dplyr::mutate( observation_concept_id = ifelse(individual_concept_id_text %in% c("Protestant Religion", "Catholic Religion", "Other",
                                                                                       "Islam", "Religion Unknown", "Pentecost Religion",
                                                                                       "Seventh Day Adventist", "Nonconformist Religion", "Nonconformist religion",
                                                                                       "Other Religion", "Protestant religion", "African  Religion",
                                                                                       "Christian, follower of religion", "African religion",
                                                                                       "Jewish, follower of religion", "No religious affiliation",
                                                                                       "Muslim, follower of religion", "Hindu, follower of religion"
                                                                                       ), 4052017, #Religion
                                              ifelse(individual_concept_id_text %in% c("8th grade / less", "High School", "No Schooling", "Secondary Education",
                                                                                       "Bachelors degree", "Some college", "8th grade/less",
                                                                                       "9th - 12th grade, no diploma", "No schooling", "Primary Education",
                                                                                       "Technical or trade school", "Bachelors degree (e.g., BA, AB, BS)",
                                                                                       "Higher Degree (Masters, Doctorate)", "Other education",
                                                                                       "Bachelors degree (e.g. BA AB BS)", "Educated to primary school level",
                                                                                       "University diploma achieved", "Masters degree (e.g. MA MS MEng MEd MSW MBA)",
                                                                                       "Doctoral degree (e.g. PhD EdD)", "Some college", "High school"
                                                                                       ), 42528763, #Highest level of Education
                                              ifelse(individual_concept_id_text %in% c("Self-employed business", "Employed", "Housewife",
                                                                                       "Unemployed", "Homemaker"
                                                                                       ), 44804285, #Employment
                                              ifelse(individual_concept_id_text %in% c("Married", "Cohabiting", "Never Married", "Separation",
                                                                                       "Widowed", "Marital Status Unknown", "Divorced", "Single",
                                                                                       "Separeted", "Single/divorced/widowed", "Separated or Divorced",
                                                                                       "Separated or divorced", "Unknown Marital Status", "Not Married"
                                                                                       ), 4053609, #Marital Status
                                              ifelse(individual_concept_id_text %in% c("Cesarean section", "Vaginal delivery of fetus",
                                                                                       "Spontaneous vaginal delivery", "Cesarean delivery"
                                                                                       ), 43054892, #Delivery Method
                                              ifelse(individual_concept_id_text %in% c("Live Birth", "Stillbirth/Fetal anomaly/IUFD"
                                                                                       ), 4264823, #Birth outcome
                                              ifelse(individual_concept_id_text %in% c("Underweight", "Normal weight", "Overweight",
                                                                                       "Obese"
                                                                                       ), 4103471, #Body Mass Index
                                              ifelse(individual_concept_id_text %in% c("gravida 0", "Primigravida", "gravida 1",
                                                                                       "gravida 2", "gravida 3", "gravida 4",
                                                                                       "gravida 5", "gravida 6", "gravida 7",
                                                                                       "gravida 8", "gravida 9", "gravida 10",
                                                                                       "gravida more than 10"
                                                                                       ), 4060186, #Gravida
                                              ifelse(individual_concept_id_text %in% c("Parity 0", "Parity 1", "Parity 2", "Parity 3",
                                                                                       "Parity 4", "Parity 5", "Parity 6", "Parity 7",
                                                                                       "Parity 8", "Parity 9", "Parity ten or more"
                                                                                       ), 4264419, #Parity
                                                     0  
                                                     )))))))))
                   ) %>%
    dplyr::arrange(observation_concept_id) %>%
    dplyr::group_by(individual_id, observation_concept_id) %>%
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
                  #Condition to remove duplicate values so as to remain with changing demographics
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
    dplyr::mutate(individual_concept_id_text = ifelse(population_study_id %in% c(1) & wave_id == 1 &
                                                        individual_concept_id_text %in% c("Cesarean section", "Vaginal delivery of fetus"),
                                                      NA, as.character(individual_concept_id_text)
                                                      ) #population study 1, wave id 1, change "Cesarean section", "Vaginal delivery of fetus" to NA
                  , individual_concept_id = ifelse(individual_concept_id_text %in% c("Cesarean section", "Cesarean delivery"), 45877865,
                                            ifelse(individual_concept_id_text %in% c("Vaginal delivery of fetus", "Spontaneous vaginal delivery"), 45885338,
                                            ifelse(individual_concept_id_text %in% c("Self-employed business"), 44803428, #4059636
                                            ifelse(individual_concept_id_text %in% c("Other Religion", "Other"), 4190569, #45878142	- other
                                            ifelse(individual_concept_id_text %in% c("Housewife", "Homemaker"), 1620877, #45438205 - Non-standard
                                            ifelse(individual_concept_id_text %in% c("Higher Degree (Masters, Doctorate)"), 3000000191, #INSPIRE study 6-11
                                            ifelse(individual_concept_id_text %in% c("Other education"), 3000000282, #INSPIRE study 6-11
                                            ifelse(individual_concept_id_text %in% c("Marital Status Unknown", "Unknown Marital Status"), 4052929,
                                                   as.numeric(individual_concept_id)
                                                   )))))))) #changing delivery methods to vaginal, CS which are answers to delivery method
                  ) %>%
    tidyr::drop_na(individual_concept_id_text) %>%
    dplyr::mutate(individual_concept_id_text = as.character(individual_concept_id_text))
  
  ## Household demographics
  observation_table_b <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id, interview_id) %>%
    dplyr::distinct() %>%
    dplyr::inner_join(staging_tables_data[["interview"]] %>%
                        dplyr::select(interview_id, individual_id, interview_date, wave_id),
                      by = c("interview_id", "individual_id")
                      ) %>%
    dplyr::distinct(individual_id, interview_date, .keep_all = TRUE) %>%
    dplyr::select(-c(interview_id)) %>%
    dplyr::inner_join(person_cdm_table[[nn]] %>%
                        dplyr::select(person_id, location_id, provider_id, care_site_id),
                      by = c("individual_id" = "person_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        dplyr::select(individual_id, household_id),
                      by = c("individual_id")
                      ) %>%
    dplyr::group_by(household_id) %>%
    dplyr::ungroup() %>%
    dplyr::inner_join( staging_tables_data[["household_characteristics"]] %>%
                         dplyr::select(-c(household_characteristics_id)) %>%
                         dplyr::mutate(household_characteristics_concept_text = trimws(household_characteristics_concept_text)
                                       , household_characteristics_concept_id = ifelse(household_characteristics_concept_text %in% c("Fishing", "Agriculture"), 4036286,
                                                                                ifelse(household_characteristics_concept_text %in% c("Remittences"), 44805930,
                                                                                ifelse(household_characteristics_concept_text %in% c("Trade"), 4011913,
                                                                                ifelse(household_characteristics_concept_text %in% c("No Income Mentioned"), 45878359,
                                                                                ifelse(household_characteristics_concept_text %in% c("Other income"), 4190569,
                                                                                ifelse(household_characteristics_concept_text %in% c("Poorest", "Very Poor", "Very poor"), 4015401,
                                                                                ifelse(household_characteristics_concept_text %in% c("Less poor", "Less Poor"), 4320353,
                                                                                ifelse(household_characteristics_concept_text %in% c("Poor", "least poor"), 4277050,
                                                                                ifelse(household_characteristics_concept_text %in% c("Household Size of One"), 4074754,
                                                                                ifelse(household_characteristics_concept_text %in% 
                                                                                         c("Household Size of Two to Four", "Household Size of Five to Nine"), 4074757,
                                                                                ifelse(household_characteristics_concept_text %in% 
                                                                                         c("Household Size of Ten to Fourteen", "Household Size of Fifteen or More"), 4052324,
                                                                                       as.numeric(household_characteristics_concept_id)
                                                                                ))))))))))) #changing Household income categories/size, socioeconomic status to standard concepts
                                       ) %>%
                         dplyr::rename( individual_concept_id = household_characteristics_concept_id
                                        ,individual_concept_id_text = household_characteristics_concept_text
                                        ) %>%
                        dplyr::filter(!individual_concept_id_text %in% c("No Answer")
                                      ),
                       by = c("household_id", "wave_id")
                       )  %>%
    tidyr::drop_na(individual_concept_id) %>%
    #Group demographics into hierachy so as to obtain unique values
    dplyr::mutate(observation_concept_id = ifelse(individual_concept_id_text %in% c( "Employed", "Unemployed", "Laborer", "Fishing",
                                                                                       "Agriculture", "Remittences", "Other income", "Trade",
                                                                                       "No Income Mentioned"
                                                                                       ), 4076114, #Household Income
                                           ifelse(individual_concept_id_text %in% c("Household Size of Five to Nine", "Household Size of One",
                                                                                       "Household Size of Ten to Fourteen",
                                                                                       "Household Size of Two to Four",
                                                                                       "Household Size of Fifteen or More"), 4075500, #household size
                                           ifelse(individual_concept_id_text %in% c("Poorest", "Poor", "Very poor", "Less poor",
                                                                                       "No Answer", "least poor", "Less Poor", "Very Poor"
                                                                                       ), 4249447, #Socioeconomic status
                                                  0
                                                  )))
                                                  
                    ) %>%
    dplyr::distinct(individual_id, interview_date, wave_id, observation_concept_id, provider_id, care_site_id, .keep_all = TRUE) %>%
    dplyr::rename(visit_start_date = interview_date) %>%
    dplyr::inner_join(staging_tables_data[["wave"]] %>%
                        dplyr::select(wave_id, name, population_study_id) %>%
                        dplyr::mutate(wave_id = ifelse(population_study_id %in% c(12) & wave_id ==33, 1,
                                                       ifelse(population_study_id %in% c(12) & wave_id ==34, 2,
                                                              ifelse(population_study_id %in% c(14) & wave_id ==36, 1, wave_id
                                                              )))
                                      #Matching wave_id for study 12,14 as is in staging. Transformed wrongly
                                      )
                      , by = c("population_study_id" = "population_study_id", "wave_id" = "wave_id")
                        ) %>%
    #interview_date linked with visit_start_date to avoid duplicate entries
    dplyr::inner_join(visit_occurrence_cdm_table[[nn]] %>%
                        dplyr::select(person_id, visit_occurrence_id, visit_start_date, visit_start_datetime, provider_id, care_site_id),
                      by = c("individual_id" = "person_id"
                             , "provider_id" = "provider_id"
                             , "care_site_id" = "care_site_id"
                             , "visit_start_date" = "visit_start_date"
                             )
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
    dplyr::mutate(individual_concept_id_text = as.character(individual_concept_id_text)) %>%
    dplyr::distinct(visit_occurrence_id, individual_concept_id_text, .keep_all = TRUE)
  
  ## Tool Questions and Responses
  observation_table_c <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
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
                  , value_as_char = trimws(value_as_char)
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
                                 ifelse(population_study_id %in% c(4,5) & concept_id == 3000000178, 45876662,
                                 ifelse(population_study_id %in% c(4,5) & concept_id == 3000000180, 45882528,
                                        as.numeric(concept_id) 
                                        )))) #population study 4 & 5 conceptid 3000000561/3000000560 to 4188539/4188540
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
    dplyr::mutate( value_type_concept_id = ifelse(instrument_item_id %in% c(10, 18, 19, 20, 21, 32, 53, 74, 109, 110
                                                                          , 111, 112, 118, 134, 135), 4112438,
                                                as.numeric(value_type_concept_id)
                                                ) #Total score of tools Generalized with Concept ID for Total( Meas value domain)
                   ) %>%
    dplyr::filter(value_type_concept_id != 4112438 #retain questions and answers and drop total scores
                  ) %>%
    dplyr::filter(!instrument_id %in% c(7) #Drop Basis 24 tool
                  ) %>%
    dplyr::left_join(staging_tables_data[["concept"]] %>%
                        dplyr::select(concept_text, concept_id) %>%
                        dplyr::distinct(concept_id, .keep_all = TRUE),
                      by = c("value_type_concept_id"="concept_id")
                      ) %>%
    dplyr::left_join(staging_tables_data[["concept"]] %>%
                        dplyr::select(concept_id, score) %>%
                        dplyr::distinct(concept_id, .keep_all = TRUE),
                      by = c("concept_id")
                      ) %>%
    dplyr::inner_join(measurement_cdm_table[[nn]] %>%
                        dplyr::select(measurement_id, person_id, measurement_concept_id, measurement_date, provider_id,
                                      visit_occurrence_id, visit_detail_id
                                      ) %>%
                        dplyr::mutate(measurement_concept_id = if_else(measurement_concept_id == 44788755, 1761569, #CES-D 
                                                               #if_else(measurement_concept_id == 40486512, 3000000266, #PSQ
                                                                       measurement_concept_id 
                                                                       ) #)
                                      )
                      , by = c("individual_id" = "person_id"
                               , "interview_date" = "measurement_date"
                               , "visit_detail_source_concept_id"= "measurement_concept_id"
                               , "provider_id"
                               , "visit_occurrence_id"
                               , "visit_detail_id"
                               ) #Get measurement id to link questions and answers to total score
                      ) %>%
    dplyr::arrange(individual_id, visit_occurrence_id) %>%
    dplyr::mutate( value_as_num = as.integer(value_as_num)
                   , value_as_num = ifelse(population_study_id %in% c(12) & is.na(value_as_num) & 
                                             instrument_item_id %in% c(1, 2, 3, 4, 5, 6, 7, 8, 9, 
                                                                       11, 12, 13, 14, 15, 16, 17),
                                           score, 
                                    ifelse(population_study_id %in% c(14) & is.na(value_as_num) &
                                             instrument_item_id %in% c(1, 2, 3, 4, 5, 6, 7, 8, 9,
                                                                       11, 12, 13, 14, 15, 16, 17,
                                                                       99, 100, 101, 102, 103, 104,
                                                                       105, 106, 107, 108
                                                                       ),
                                           score, value_as_num
                                        )) #Replace NA values for PHQ9, GAD7, PSQ responses with scores for population study 12,14
                  ) %>%
    dplyr::mutate(visit_detail_source_concept_id = ifelse(visit_detail_source_concept_id == 4164838, 42870296, #EPDS panel concept_id
                                                   ifelse(visit_detail_source_concept_id == 44804610, 40772147, #PHQ-9 panel concept_id
                                                   ifelse(visit_detail_source_concept_id == 45772733, 40772159, #GAD-7 panel concept_id
                                                   ifelse(visit_detail_source_concept_id == 37310582, 3966135, #PCL-5 panel concept_id
                                                          as.numeric(visit_detail_source_concept_id)
                                                          )))) #Change concept id for tools to observation domain
                  ) %>%
    dplyr::select(individual_id, value_type_concept_id, interview_date, visit_detail_start_datetime, value_as_num,
                  value_as_char, concept_id, concept_text, provider_id, visit_occurrence_id, visit_detail_id,
                  measurement_id, visit_detail_source_concept_id
                  ) %>%
    dplyr::rename(person_id = individual_id
                  #, observation_concept_id = visit_detail_source_concept_id
                  , observation_concept_id = value_type_concept_id
                  , observation_date = interview_date
                  , observation_datetime = visit_detail_start_datetime
                  , value_as_number = value_as_num
                  #, value_as_string = concept_text
                  , value_as_string = value_as_char
                  #, value_as_concept_id = value_type_concept_id
                  , value_as_concept_id = concept_id
                  #, value_source_value = value_as_num
                  , value_source_value = concept_text
                  , observation_event_id = measurement_id
                  #, qualifier_concept_id = concept_id
                  #, qualifier_source_value = value_as_char
                  ) %>%
      dplyr::mutate(observation_type_concept_id = 32883
                    , observation_source_value = value_as_string
                    , observation_source_concept_id = value_as_concept_id
                    , obs_event_field_concept_id = 1147138 #concept id for measurement.measurement_id for CDM v5
                    , value_source_value = as.character(value_source_value)
                    , qualifier_concept_id = NA
                    , qualifier_source_value = NA
                    ) %>%
    tidyr::drop_na(value_as_concept_id) %>%
    dplyr::filter(value_as_string != "null" #study 5 
                  )
  
  observation_table <- dplyr::bind_rows(observation_table_a, observation_table_b) %>%
    dplyr::arrange(individual_id) %>%
    dplyr::mutate( observation_id = 1:n()
                   , observation_source_value = individual_concept_id_text
                   , observation_source_concept_id = as.numeric(individual_concept_id)
                   , observation_type_concept_id = 32883
                   , value_as_number = NA
                   , value_as_concept_id = as.numeric(individual_concept_id) #Changed from NULL
                   , qualifier_concept_id = NA
                   , unit_concept_id = NA
                   , qualifier_source_value = NA
                   , unit_source_value = NA
                   , value_source_value = NA
                   , observation_event_id = NA
                   , obs_event_field_concept_id = NA
                   ) %>%
    dplyr::rename(person_id = individual_id
                  , observation_date = visit_start_date
                  , observation_datetime = visit_start_datetime
                  , value_as_string = individual_concept_id_text
                  )
  
  observation_table_final <- dplyr::bind_rows(observation_table, observation_table_c) %>%
    dplyr::arrange(person_id, observation_concept_id, visit_occurrence_id, visit_detail_id) %>%
    dplyr::mutate(observation_id = 1:n()
                  ) %>%
    dplyr::select(observation_id, person_id, observation_concept_id, observation_date, observation_datetime
                  , observation_type_concept_id, value_as_number, value_as_string, value_as_concept_id
                  , qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id, visit_detail_id
                  , observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value
                  , value_source_value, observation_event_id, obs_event_field_concept_id
                  ) %>%
    dplyr::mutate(across(c(observation_source_value, value_source_value, qualifier_source_value), ~strtrim(.x, 49)
                         )
                  , across(c(observation_concept_id, value_as_concept_id, observation_source_concept_id), 
                           ~if_else(.x > 3000000000, .x - 1000000000, .x
                                    ) #change INSPIRE concepts to 2 billion
                           )
                  , value_as_string = strtrim(value_as_string, 59)
                  )
  
  }, simplify = FALSE
  )

 
## Loading to CDM tables
 
 observation_cdm_load <- sapply(names(observation_cdm_table), function(x){
   nn <- x 
   
   interest_table <- "observation"
   
   ## Inserting data to specific schema and table
     DBI::dbWriteTable(con
                       , name = Id(schema = nn, table = interest_table)
                       , value = observation_cdm_table[[nn]]
                       , overwrite = TRUE
                       , row.names = FALSE
                       , field.types = c(observation_id="integer", person_id="integer", observation_concept_id="integer"
                                         , observation_date="date", observation_datetime="timestamp without time zone"
                                         , observation_type_concept_id="integer", value_as_number="numeric", value_as_string="character varying (60)"
                                         , value_as_concept_id="integer", qualifier_concept_id="integer", unit_concept_id="integer", provider_id="integer"
                                         , visit_occurrence_id="integer", visit_detail_id="integer", observation_source_value="character varying (50)"
                                         , observation_source_concept_id="integer", unit_source_value="character varying (50)"
                                         , qualifier_source_value="character varying (50)", value_source_value="character varying (50)" 
                                         , observation_event_id="integer", obs_event_field_concept_id="integer"
                                         )
                       )
    
    #to accomodate inspire concepts observation_concept_id="bigint" supposed to be observation_concept_id="integer"
    #to accomodate inspire concepts observation_source_concept_id="bigint" supposed to be observation_source_concept_id="integer" 
    #to accomodate inspire concepts value_as_concept_id="bigint" supposed to be value_as_concept_id="integer"
     
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
     DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.observation ADD CONSTRAINT xpk_observation PRIMARY KEY (observation_id);
                                                          ")
                      )
  
}, simplify = FALSE
)
 


