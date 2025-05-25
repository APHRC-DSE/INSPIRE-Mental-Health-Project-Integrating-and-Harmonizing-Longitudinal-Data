library(RPostgres)
library(DBI)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

## CDM Source table Transformation

cdm_source_cdm_table <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  study_id <- readr::parse_number(nn)
  
  cdm_source_cdm_table <- staging_tables_data[["population_study"]] %>%
    dplyr::filter(population_study_id == study_id) %>%
    dplyr::mutate( cdm_holder = "APHRC"
                   , cdm_source_abbreviation = data_source
                   , cdm_version_concept_id = 756265
                   , vocabulary_version = "v5.0 30-AUG-24"
                   , cdm_version = "5.4"
                   , cdm_etl_reference = "https://github.com/APHRC-DSE/INSPIRE-Mental-Health-Project-Integrating-and-Harmonizing-Longitudinal-Data"
                   , source_release_date = version_date
                   , cdm_release_date = Sys.Date()
                   , url = ifelse(is.na(url), name, url)
                   ) %>%
    dplyr::rename( cdm_source_name = name
                   , source_description = description
                   , source_documentation_reference = url
                   #, cdm_release_date = version_date
                   ) %>%
    dplyr::select( cdm_source_name, cdm_source_abbreviation, cdm_holder, source_description, source_documentation_reference
                   , cdm_etl_reference, source_release_date, cdm_release_date, cdm_version, cdm_version_concept_id
                   , vocabulary_version
                   )
  
}, simplify = FALSE
)



## Loading to CDM tables

cdm_source_cdm_load <- sapply(names(cdm_source_cdm_table), function(x){
  nn <- x 
  
  interest_table <- "cdm_source"
  
  ## Inserting data to specific schema and table
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = interest_table)
                      , value = cdm_source_cdm_table[[nn]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(cdm_source_name="character varying (255)", cdm_source_abbreviation="character varying (25)"
                                        , cdm_holder="character varying (255)", source_description="text"
                                        , source_documentation_reference="character varying (255)", cdm_etl_reference="character varying (255)"
                                        , source_release_date="date", cdm_release_date="date", cdm_version="character varying (10)"
                                        , cdm_version_concept_id="integer", vocabulary_version="character varying (20)"
                                        )
                      )
  
}, simplify = FALSE
)
