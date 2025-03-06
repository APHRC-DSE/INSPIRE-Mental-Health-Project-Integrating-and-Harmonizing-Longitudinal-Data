library(RPostgres)
library(DBI)
library(dplyr)
library(lubridate)
library(tidyr)

## Person CDM table Transformation

person_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  person_table <- staging_tables_data[["longitudinal_population_study_fact"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::select(population_study_id, individual_id) %>%
    dplyr::distinct(individual_id, .keep_all = TRUE) %>%
    dplyr::inner_join(staging_tables_data[["population_study"]] %>%
                        dplyr::distinct(population_study_id, .keep_all = TRUE) %>%
                        dplyr::select(country, universe_spatial_coverage_concept_id, population_study_id),
                      by = c("population_study_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["individual"]] %>%
                        tidyr::drop_na(year_of_birth) %>% #If no year of birth is available all the person’s data should be dropped from the CDM instance.
                        dplyr::select(individual_id, individual_id_value, gender_concept_id, year_of_birth, household_id),
                      by = c("individual_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["household"]] %>%
                        dplyr::select(household_id, location_id),
                      by = c("household_id")
                      ) %>%
    dplyr::inner_join(staging_tables_data[["location"]] %>%
                        dplyr::select(location_id, village_name, place_kind),
                      by = c("location_id")
                      ) %>%
    dplyr::rename(location_id_old = location_id) %>%
    dplyr::inner_join(location_cdm_table[[nn]] %>%
                        dplyr::select(location_id, location_source_value, address_1),
                      by = c("village_name" = "location_source_value"
                             , "place_kind" = "address_1")
                      ) %>%
    dplyr::inner_join( caresite_cdm_table[[nn]] %>%
                         dplyr::select(care_site_id, location_id),
                       by = c("location_id")
                       ) %>%
    dplyr::inner_join( provider_cdm_table[[nn]] %>%
                         dplyr::select(care_site_id, provider_id),
                       by = c("care_site_id")
                       ) %>%
    dplyr::left_join( staging_tables_data[["individual_demographics"]] %>%
                        dplyr::mutate(individual_concept_id_text = trimws(individual_concept_id_text)
                                      ) %>%
                        dplyr::select(-individual_demographics_id ) %>%
                        dplyr::filter(individual_concept_id_text %in% c("Coloured", "Asian/Indian", "African", "White")
                                      ) %>% 
                        dplyr::distinct(individual_id, .keep_all = TRUE) %>%
                        dplyr::rename(race_source_value = individual_concept_id_text,
                                      race_concept_id = individual_concept_id
                                      ),
                       by = c("individual_id")
                       ) %>%
    dplyr::left_join( staging_tables_data[["individual_demographics"]] %>%
                        dplyr::mutate(individual_concept_id_text = trimws(individual_concept_id_text)
                                      ) %>%
                        dplyr::select(-individual_demographics_id ) %>%
                        dplyr::filter(individual_concept_id_text %in% c("Not Hispanic or Latino")
                                      ) %>% 
                        dplyr::distinct(individual_id, .keep_all = TRUE) %>%
                        dplyr::rename(ethnicity_source_value = individual_concept_id_text,
                                      ethnicity_concept_id = individual_concept_id
                                      ),
                       by = c("individual_id")
                       ) %>%
    dplyr::mutate( birth_date = lubridate::ymd(paste0(year_of_birth, "-06-15")) #If only year of birth is given, use the 15th of June of that year.
                   , month_of_birth = lubridate::month(birth_date)
                   , day_of_birth = lubridate::day(birth_date)
                   , birth_datetime = lubridate::as_datetime(birth_date, tz = "UTC")
                   , gender_source_value = ifelse(gender_concept_id == 8532, "Female",
                                                  ifelse(gender_concept_id == 8507, "Male", NA 
                                                         )
                                                  )
                   , ethnicity_concept_id = tidyr::replace_na(ethnicity_concept_id, 38003564)
                   , ethnicity_source_value = tidyr::replace_na(ethnicity_source_value,"Not Hispanic or Latino")
                   , gender_source_concept_id = 0
                   , race_source_concept_id = 0
                   , ethnicity_source_concept_id = as.numeric(universe_spatial_coverage_concept_id)
                   , across(c(gender_concept_id, race_concept_id), ~tidyr::replace_na(.x, 0))
                   ) %>%
    dplyr::rename(person_id = individual_id
                  , person_source_value = individual_id_value
                  ) %>%
    dplyr::select(person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, birth_datetime, race_concept_id
                  , ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value
                  , gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value
                  , ethnicity_source_concept_id
                  )
  
}, simplify = FALSE
)


## Loading to CDM tables

person_cdm_load <- sapply(names(person_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "person"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = person_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(person_id="integer", gender_concept_id= "integer", year_of_birth="integer",
                                        month_of_birth="integer", day_of_birth="integer", birth_datetime="timestamp without time zone",
                                        race_concept_id="integer", ethnicity_concept_id= "integer", location_id="integer",
                                        provider_id= "integer", care_site_id="integer", person_source_value="character varying (50)",
                                        gender_source_value="character varying (50)", gender_source_concept_id="integer",
                                        race_source_value="character varying (50)", race_source_concept_id="integer",
                                        ethnicity_source_value="character varying (50)", ethnicity_source_concept_id="integer"
                                        )
                      )
    
  ## CDM Primary Key Constraints for OMOP Common Data Model 5.4
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.person ADD CONSTRAINT xpk_person PRIMARY KEY (person_id);
                                                          ")
                     )
  
}, simplify = FALSE
)
