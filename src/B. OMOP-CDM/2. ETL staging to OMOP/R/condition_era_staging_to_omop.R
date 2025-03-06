library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)

## Condition era CDM table Transformation

condition_era_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  condition_era_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::select(population_study_id, individual_id) %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::distinct(individual_id, .keep_all = TRUE) %>%
    dplyr::inner_join(condition_occurrence_cdm_table[[nn]] %>%
                        dplyr::select(condition_occurrence_id, person_id, condition_concept_id, condition_start_date),
                      by = c("individual_id" = "person_id")
                      ) %>%
    dplyr::group_by(individual_id, condition_concept_id) %>%
    dplyr::summarise(condition_era_start_date = min(condition_start_date)
                     , condition_era_end_date = max(condition_start_date)
                     , condition_occurrence_count = length(individual_id)
                     , .groups = "drop"
                     ) %>%
    dplyr::mutate(condition_era_id = 1:n()
                  ) %>%
    dplyr::rename(person_id = individual_id) %>%
    dplyr::select(condition_era_id, person_id, condition_concept_id, condition_era_start_date, condition_era_end_date,
                  condition_occurrence_count
                  )
    
}, simplify = FALSE
)

## Loading to CDM tables

condition_era_cdm_load <- sapply(names(condition_era_cdm_table), function(x){
  nn <- x
  
  interest_table <- "condition_era"
  
  ## Inserting data to specific schema and table
   DBI::dbWriteTable(con
                     , name = Id(schema = nn, table = interest_table)
                     , value = condition_era_cdm_table[[nn]]
                     , overwrite = TRUE
                     , row.names = FALSE
                     , field.types = c(condition_era_id="integer", person_id= "integer", condition_concept_id="integer",
                                       condition_era_start_date="date", condition_era_end_date="date", 
                                       condition_occurrence_count="integer"
                                       )
                      )
   
   ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
   DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.condition_era ADD CONSTRAINT xpk_condition_era PRIMARY KEY (condition_era_id);
                                                          ")
                    )
  
}, simplify = FALSE
)

