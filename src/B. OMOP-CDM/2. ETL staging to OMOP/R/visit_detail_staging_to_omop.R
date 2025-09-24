library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

## Visit Detail CDM table Transformation

visit_detail_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  visit_detail_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id, interview_id) %>%
    dplyr::distinct() %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        dplyr::select(individual_id, individual_id_value),
                      by = c("individual_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["interview"]],
                      by = c("interview_id", "individual_id")
                      ) %>%
    dplyr::inner_join( person_cdm_table[[nn]] %>%
                         dplyr::select(person_id, person_source_value, provider_id, care_site_id),
                       by = c("individual_id_value" = "person_source_value")
                       ) %>%
    dplyr::inner_join( visit_occurrence_cdm_table[[nn]] %>%
                         dplyr::select(visit_occurrence_id, person_id, visit_start_date, provider_id, care_site_id),
                       by = c("person_id" = "person_id", "interview_date" = "visit_start_date",
                              "provider_id" = "provider_id", "care_site_id" = "care_site_id"
                              )
                       )  %>%
    dplyr::arrange(individual_id, instrument_id, visit_occurrence_id) %>%
    dplyr::filter(!instrument_id %in% c(7) #Drop Basis 24 tool
                  ) %>%
    dplyr::mutate(visit_detail_id = 1:n()
                  , visit_detail_concept_id = 581476
                  , visit_detail_start_datetime = lubridate::as_datetime(interview_date, tz = "UTC")
                  , visit_detail_end_date = interview_date
                  , visit_detail_end_datetime = lubridate::as_datetime(interview_date, tz = "UTC")
                  , visit_detail_type_concept_id = 32883
                  , visit_detail_source_value = "Home Visit"
                  , visit_detail_source_concept_id = if_else(instrument_id == 1, 44804610, #measurement domain
                                                      if_else(instrument_id == 2, 45772733, #measurement domain
                                                      if_else(instrument_id == 3, 2000000219, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 4, 4164838, #measurement domain
                                                      if_else(instrument_id == 5, 37310582, #measurement domain
                                                      if_else(instrument_id == 6, 1761569, #observation domain
                                                      if_else(instrument_id == 7, 2000000223,
                                                      if_else(instrument_id == 8, 36714019, #measurement domain
                                                      if_else(instrument_id == 9, 1988691, #observation domain
                                                      if_else(instrument_id == 10, 2000000226, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 11, 2000000227, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 12, 2000000228, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 13, 2000000229, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 14, 2000000230, #INSPIRE concepts to 2 billion
                                                      if_else(instrument_id == 15, 44783153, #measurement domain
                                                      if_else(instrument_id == 16, 2000000266, 0
                                                              ))))))))))))))))
                  , admitted_from_concept_id = 581476
                  , admitted_from_source_value = "Home Visit"
                  , discharged_to_concept_id = 581476
                  , discharged_to_source_value = "Home Visit"
                  , preceding_visit_detail_id = visit_detail_id
                  , parent_visit_detail_id = NA
                  ) %>%
    dplyr::rename( visit_detail_start_date = interview_date) %>%
    dplyr::group_by(individual_id, visit_detail_source_concept_id) %>%
    dplyr::mutate(first_visit_detail_id = min(visit_detail_id)
                  ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(preceding_visit_detail_id = ifelse(preceding_visit_detail_id==first_visit_detail_id, NA,
                                                     preceding_visit_detail_id-1)
                  ) %>%
    dplyr::select( visit_detail_id, person_id, visit_detail_concept_id, visit_detail_start_date, visit_detail_start_datetime,
                   visit_detail_end_date, visit_detail_end_datetime, visit_detail_type_concept_id, provider_id, care_site_id,
                   visit_detail_source_value, visit_detail_source_concept_id, admitted_from_concept_id,
                   admitted_from_source_value, discharged_to_source_value, discharged_to_concept_id,
                   preceding_visit_detail_id, parent_visit_detail_id, visit_occurrence_id
                   )
    
}, simplify = FALSE
)


## Loading to CDM tables

visit_detail_cdm_load <- sapply(names(visit_detail_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "visit_detail"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = visit_detail_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(visit_detail_id="integer", person_id= "integer", visit_detail_concept_id="integer",
                                        visit_detail_start_date="date", visit_detail_start_datetime="timestamp without time zone",
                                        visit_detail_end_date="date", visit_detail_end_datetime="timestamp without time zone",
                                        visit_detail_type_concept_id="integer", provider_id= "integer", care_site_id="integer",
                                        visit_detail_source_value= "character varying (50)", visit_detail_source_concept_id="integer",
                                        admitted_from_concept_id="integer", admitted_from_source_value="character varying (50)", 
                                        discharged_to_source_value="character varying (50)", discharged_to_concept_id="integer",
                                        preceding_visit_detail_id="integer", parent_visit_detail_id="integer", visit_occurrence_id="integer"
                                        )
                      )
    
    #to accomodate inspire concepts visit_detail_source_concept_id="bigint" supposed to be visit_detail_source_concept_id="integer"
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.visit_detail ADD CONSTRAINT xpk_visit_detail PRIMARY KEY (visit_detail_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
