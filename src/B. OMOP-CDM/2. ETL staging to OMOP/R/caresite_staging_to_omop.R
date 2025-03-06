library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)

## Care Site CDM table Transformation

caresite_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  caresite_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::select(population_study_id) %>%
    dplyr::inner_join(staging_tables_data[["population_study"]] %>%
                        dplyr::select(country, name, population_study_id),
                      by = c("population_study_id")
                      ) %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::distinct() %>%
    dplyr::inner_join(location_cdm_table[[nn]] %>%
                        dplyr::select(location_id, country_source_value),
                      by = c("country" = "country_source_value")
                      ) %>%
    dplyr::mutate(care_site_id = 1:n()
                  , place_of_service_concept_id = 581476 #Homevisit Changed from NA
                  , place_of_service_source_value = NA
                  ) %>%
    dplyr::rename(care_site_name = country
                  ,care_site_source_value = name
                  ) %>%
    dplyr::select(care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value,
                  place_of_service_source_value
                  ) %>%
    dplyr::mutate(care_site_source_value = strtrim(care_site_source_value, 49)
                  )
  
}, simplify = FALSE
)


## Loading to CDM tables

caresite_cdm_load <- sapply(names(caresite_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "care_site"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = caresite_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(care_site_id="integer", care_site_name= "character varying (255)",
                                        place_of_service_concept_id="integer", location_id="integer",
                                        care_site_source_value="character varying (50)", 
                                        place_of_service_source_value= "character varying (50)"
                                        )
                      )
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.care_site  ADD CONSTRAINT xpk_care_site PRIMARY KEY (care_site_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
