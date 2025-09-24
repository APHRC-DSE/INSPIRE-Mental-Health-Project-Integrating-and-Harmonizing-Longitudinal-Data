library(RPostgres)
library(DBI)

working_directory


## Set the search path to the staging schema

dbExecute(con, sprintf("SET search_path TO %s", staging_schema_name))

list_staging_tables <- DBI::dbListTables(con)

#list_staging_tables <- DBI::dbListObjects(con, DBI::Id(schema = staging_schema_name))

## Read tables in selected scheme
staging_tables_data <- sapply(list_staging_tables, function(x){
  nn <- x
  
  read_tables <- DBI::dbReadTable(con, nn)
    
  if ( staging_schema_name == "mh_staging_1_1_dev_aug" && nn == "interview" ) {
    #study13 missing interview_date and instrument_id for psq-tool from 8 to 16
    read_tables %>%
      dplyr::left_join(df_list[["study_13_person.csv"]] %>% 
                         dplyr::select(individual_id, consentdate, wave_id)
                       , by = c("individual_id", "wave_id")
                       ) %>%
      dplyr::mutate(interview_date = if_else(is.na(interview_date) & wave_id == 35, consentdate,interview_date)
                    , instrument_id = if_else(wave_id == 35 & instrument_id == 8, 16, instrument_id) 
                    ,across(c(individual_id, wave_id, instrument_id), ~as.integer(.x))
                    ) %>%
      dplyr::select(-consentdate)
    
  } else if (staging_schema_name == "mh_staging_1_1_dev_aug" && nn == "longitudinal_population_study_fact") {
    #aligning interview_id for study13 and instrument_id for psq-tool from 8 to 16
    read_tables %>%
      dplyr::filter(!value_as_concept %in% c(3000000270, 3000000275) #remove extra rows for study 13 psq tool
                    ) %>%
      dplyr::mutate(interview_id = if_else(population_study_id == 13 & instrument_id == 2, interview_id+1,
                                           if_else(population_study_id == 13 & instrument_id == 8, interview_id+2, interview_id
                                                   ))
                    , instrument_item_id = if_else(population_study_id == 13 & instrument_id == 8 
                                                   & instrument_item_id %in% c(102, 103, 104, 105), instrument_item_id-1,
                                           if_else(population_study_id == 13 & instrument_id == 8 
                                                   & instrument_item_id %in% c(107, 108, 109, 110, 111), instrument_item_id-2,
                                                   instrument_item_id))
                    , value_type_concept_id = if_else(population_study_id == 13 & instrument_id == 8 
                                                      & value_type_concept_id %in% c(3000000271, 3000000272, 3000000273, 3000000274),
                                                      value_type_concept_id-1,
                                              if_else(population_study_id == 13 & instrument_id == 8 
                                                      & value_type_concept_id %in% c(3000000276, 3000000277, 3000000278, 3000000279, 3000000280),
                                                      value_type_concept_id-2, value_type_concept_id))
                    , value_as_concept = if_else(population_study_id == 13 & instrument_id == 8 
                                                 & value_as_concept %in% c(3000000271, 3000000272, 3000000273, 3000000274),
                                                 value_as_concept-1,
                                         if_else(population_study_id == 13 & instrument_id == 8 
                                                 & value_as_concept %in% c(3000000276, 3000000277, 3000000278, 3000000279, 3000000280),
                                                 value_as_concept-2, value_as_concept))
                    , instrument_id = if_else(population_study_id == 13 & instrument_id == 8, instrument_id+8, instrument_id)
                    , value_as_num = if_else(population_study_id == 13 & instrument_id == 16 & instrument_item_id == 109
                                                   & value_as_num > 0, value_as_num-2, value_as_num)
                    , value_as_num = if_else(population_study_id == 13 & instrument_id == 16 & instrument_item_id == 109
                                             & value_as_num < 0, 0, value_as_num)
                    ) 
    } else {
      read_tables
      }
  
}, simplify = FALSE
)

