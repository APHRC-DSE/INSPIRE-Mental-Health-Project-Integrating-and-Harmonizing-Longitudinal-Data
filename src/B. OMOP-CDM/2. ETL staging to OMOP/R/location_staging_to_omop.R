library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)

## Location CDM table Transformation

location_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  location_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::select(population_study_id, individual_id) %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::inner_join(staging_tables_data[["population_study"]] %>%
                        dplyr::select(country, universe_spatial_coverage_concept_id, population_study_id),
                      by = c("population_study_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        dplyr::select(individual_id, household_id),
                      by = c("individual_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["household"]] %>%
                        dplyr::select(household_id, location_id),
                      by = c("household_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["location"]],
                      by = c("location_id")
                      ) %>%
    dplyr::mutate(country_concept_id = as.numeric(universe_spatial_coverage_concept_id)
                  , latitude = if_else(population_study_id == 14 & village_name == "Charo wa mae", -3.6239466,
                               if_else(population_study_id == 14 & village_name == "Juakali", -3.5753049, 
                               if_else(population_study_id == 14 & village_name == "Kasarani", -3.230491, 
                               if_else(population_study_id == 14 & village_name == "Kisumu ndogo", -3.2193128, 
                               if_else(population_study_id == 14 & village_name == "Mavueni", -3.6228921, 
                               if_else(population_study_id == 14 & village_name == "Mnarani", -3.6564446, 
                                       latitude
                                       )))))) #latitude for population study 14 missing
                  , longitude = if_else(population_study_id == 14 & village_name == "Charo wa mae", 39.8483414,
                                if_else(population_study_id == 14 & village_name == "Juakali", 39.1936074, 
                                if_else(population_study_id == 14 & village_name == "Kasarani", 40.0699973, 
                                if_else(population_study_id == 14 & village_name == "Kisumu ndogo", 40.1164891, 
                                if_else(population_study_id == 14 & village_name == "Mavueni", 39.8287295, 
                                if_else(population_study_id == 14 & village_name == "Mnarani", 39.8199827, 
                                        longitude
                                        )))))) #longitude for population study 14 missing
                  ) %>%
    dplyr::group_by(village_name, place_kind, country, country_concept_id) %>%
    dplyr::summarise(latitude = round(median(latitude, na.rm = TRUE), 4)
                     , longitude = round(median(longitude, na.rm = TRUE), 4)
                     , .groups = "drop"
                     ) %>%
    dplyr::distinct() %>%
    dplyr::mutate(location_id = 1:n()
                  , address_2 = NA
                  , city = NA
                  , state = NA
                  , zip = NA
                  , county = NA
                  ) %>%
    dplyr::rename(address_1 = place_kind
                  ,location_source_value = village_name
                  , country_source_value = country
                  ) %>%
    dplyr::select(location_id, address_1, address_2 , city, state, zip, county, location_source_value,
                  country_concept_id, country_source_value, latitude, longitude) 
    
}, simplify = FALSE
)

## Loading to CDM tables

location_cdm_load <- sapply(names(location_cdm_table), function(x){
  nn <- x
  
  interest_table <- "location"
  
  ## Inserting data to specific schema and table
   DBI::dbWriteTable(con
                     , name = Id(schema = nn, table = interest_table)
                     , value = location_cdm_table[[nn]]
                     , overwrite = TRUE
                     , row.names = FALSE
                     , field.types = c(location_id="integer", address_1= "character varying (50)", address_2="character varying (50)",
                                       city="character varying (50)", state="character varying (2)", zip="character varying (9)",
                                       county= "character varying (20)", location_source_value="character varying (50)",
                                       country_concept_id= "integer", country_source_value="character varying (80)",
                                       latitude="numeric", longitude="numeric"
                                       )
                      )
   
   ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
   DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.location ADD CONSTRAINT xpk_location PRIMARY KEY (location_id);
                                                          ")
                    )
  
}, simplify = FALSE
)

