library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(lubridate)

## Observation Period CDM table Transformation

observation_period_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  observation_period_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id, interview_id) %>%
    dplyr::inner_join( staging_tables_data[["interview"]] %>%
                        dplyr::select(interview_id, individual_id, interview_date, wave_id),
                      by = c("interview_id", "individual_id")
                      ) %>%
    dplyr::inner_join( person_cdm_table[[nn]] %>%
                         dplyr::select( person_id, person_source_value, gender_source_value),
                       by = c("individual_id"= "person_id")
                       ) %>%
    dplyr::group_by(individual_id) %>%
    dplyr::summarise(observation_period_start_date = min(interview_date)
                     , observation_period_end_date = max(interview_date)
                     , .groups = "drop"
                     ) %>%
    dplyr::arrange(individual_id) %>%
    dplyr::mutate(observation_period_id = 1:n()
                  , period_type_concept_id = 32883
                  ) %>%
    dplyr::rename( person_id = individual_id) %>%
    dplyr::select( observation_period_id, person_id, observation_period_start_date, observation_period_end_date,
                   period_type_concept_id
                   )
    
}, simplify = FALSE
)


## Loading to CDM tables

observation_period_cdm_load <- sapply(names(observation_period_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "observation_period"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = observation_period_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(observation_period_id="integer", person_id= "integer", 
                                        observation_period_start_date="date", observation_period_end_date="date",
                                        period_type_concept_id="integer"
                                        )
                      )
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.observation_period ADD CONSTRAINT xpk_observation_period PRIMARY KEY (observation_period_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
