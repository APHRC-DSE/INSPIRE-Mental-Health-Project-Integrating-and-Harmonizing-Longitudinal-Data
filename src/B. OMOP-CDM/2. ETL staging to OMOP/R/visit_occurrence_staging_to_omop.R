library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(lubridate)

## Visit Occurrence CDM table Transformation

visit_occurrence_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  visit_occurrence_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id, interview_id) %>%
    #dplyr::distinct() %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        dplyr::select(individual_id, individual_id_value),
                      by = c("individual_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["interview"]],
                      by = c("interview_id", "individual_id")
                      ) %>%
    dplyr::distinct(population_study_id, individual_id, individual_id_value, interview_date, wave_id) %>%
    dplyr::inner_join( person_cdm_table[[nn]] %>%
                         dplyr::select(person_id, person_source_value, provider_id, care_site_id),
                       by = c("individual_id_value" = "person_source_value")
                       ) %>%
    dplyr::arrange(individual_id, wave_id) %>%
    dplyr::mutate(visit_occurrence_id = 1:n()
                  , visit_concept_id = 581476
                  , visit_type_concept_id = 32883
                  , visit_start_datetime = lubridate::as_datetime(interview_date, tz = "UTC")
                  , visit_end_date = interview_date
                  , visit_end_datetime = lubridate::as_datetime(interview_date, tz = "UTC")
                  , visit_source_value = NA
                  , visit_source_concept_id = 0
                  , admitted_from_concept_id = 581476
                  , admitted_from_source_value = "Home Visit"
                  , discharged_to_concept_id = 581476
                  , discharged_to_source_value = "Home Visit"
                  , preceding_visit_occurrence_id = visit_occurrence_id
                  ) %>%
    dplyr::rename( visit_start_date = interview_date) %>%
    dplyr::group_by(individual_id) %>%
    dplyr::mutate(first_visit_occurence_id = min(visit_occurrence_id)
                  ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(preceding_visit_occurrence_id = ifelse(preceding_visit_occurrence_id==first_visit_occurence_id, NA,
                                                         preceding_visit_occurrence_id-1)
                  ) %>%
    dplyr::select( visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_datetime,
                   visit_end_date, visit_end_datetime, visit_type_concept_id, provider_id, care_site_id,
                   , visit_source_value, visit_source_concept_id, admitted_from_concept_id, admitted_from_source_value
                   , discharged_to_concept_id, discharged_to_source_value, preceding_visit_occurrence_id
                   )
  
}, simplify = FALSE
)


## Loading to CDM tables

visit_occurrence_cdm_load <- sapply(names(visit_occurrence_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "visit_occurrence"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = visit_occurrence_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(visit_occurrence_id="integer", person_id= "integer", visit_concept_id="integer",
                                        visit_start_date="date", visit_start_datetime="timestamp without time zone",
                                        visit_end_date="date", visit_end_datetime="timestamp without time zone",
                                        visit_type_concept_id="integer", provider_id= "integer", care_site_id="integer",
                                        visit_source_value= "character varying (50)", visit_source_concept_id="integer",
                                        admitted_from_concept_id="integer", admitted_from_source_value="character varying (50)", 
                                        discharged_to_concept_id="integer", discharged_to_source_value="character varying (50)",
                                        preceding_visit_occurrence_id="integer"
                                        )
                      )
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.visit_occurrence ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY (visit_occurrence_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
