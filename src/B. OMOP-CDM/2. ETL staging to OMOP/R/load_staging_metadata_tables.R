library(RPostgres)
library(DBI)
library(readr)
library(lubridate)
library(glue)

working_directory

# Loading metadata in staging Tables

##list files in data folder
data_files <- list.files(path = base::file.path(data_Dir, "staging metadata"), full.names = F)

##load all csv files
df_list <- sapply(data_files[grepl(".csv$",data_files)], function(z){
  
  if (z == "study_13_person.csv") {
    readr::read_csv(base::file.path(data_Dir, "staging metadata", z)) %>%
      dplyr::mutate(consentdate = lubridate::dmy(consentdate))
  } else {
    readr::read_csv(base::file.path(data_Dir, "staging metadata", z))
  }
  
}, simplify=FALSE)

## Load metadata to tables
load_staging_metadata <- sapply(list_all_schemas_metadata$schema_name[grepl("^mh_staging_1_", list_all_schemas_metadata$schema_name)], function(x){
  nn <- x
  
  query_set_search_path <- DBI::dbExecute(con, sprintf("SET search_path TO %s", nn))
  
  list_schema_tables <- DBI::dbListTables(con)
  
  #Add column to population study table and concept table
  
  alter_population_study_table <- DBI::dbSendQuery(con, glue::glue("
  ALTER TABLE {nn}.population_study ADD COLUMN IF NOT EXISTS data_source VARCHAR(50);
                      ")
                                                   )

  alter_concept_table <- DBI::dbSendQuery(con, glue::glue("
  ALTER TABLE {nn}.concept ADD COLUMN IF NOT EXISTS domain TEXT;
                                                          ")
                                          )
  
  # Load metadata to tables 
  data_exists <- sapply(list_schema_tables, function(y){
    DBI::dbGetQuery(con, paste0("SELECT CASE 
    WHEN EXISTS (SELECT * FROM ", y , " LIMIT 1) THEN 1
    ELSE 0 
    END;")
                    )
   }, simplify = FALSE
   )
  
  ## Concept metadata
  load_concept_metadata <- if (data_exists[["concept"]]$case == 1) {
      print("Metadata exists in concept table")
  } else {
    
    DBI::dbSendQuery(con, glue::glue("SET client_encoding = WIN1252;"))
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "concept")
                      , value = df_list[["concept.csv"]] %>%
                        dplyr::mutate(across(c(start_date, end_date), ~lubridate::dmy(.x))
                                      )
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(concept_vocabulary="text", concept_code= "text", concept_text="text",
                                        start_date="date", end_date="date", inspire_concept_id= "double precision",
                                        concept_id="double precision", score= "text", domain="text"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("SET client_encoding TO 'UTF8';"))
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.concept ADD PRIMARY KEY (inspire_concept_id);
                                                          ")
                     )
    
      }
  
  ## Data capture event metadata
  load_data_capture_event_metadata <- if (data_exists[["data_capture_event"]]$case == 1) {
    print("Metadata exists in data capture event table")
    
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "data_capture_event")
                      , value = df_list[["data_capture_event.csv"]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(data_capture_id="integer", wave_id= "integer", instrument_id="integer",
                                        completion_status="character varying (50)", data_quality_indicator="character varying (255)",
                                        mode_of_collection_description= "character varying (255)",
                                        mode_of_collection_type="character varying (255)",
                                        data_capture_collector= "character varying (255)",
                                        data_source_description="character varying (255)", 
                                        data_source_type="character varying (255)", 
                                        data_capture_event_date="date"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.data_capture_event ADD PRIMARY KEY (data_capture_id);
                                                          ")
                     )
    
    }
  
  ## instrument item metadata
  load_instrument_item_metadata <- if (data_exists[["instrument_item"]]$case == 1) {
    print("Metadata exists in instrument item table")
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "instrument_item")
                      , value = df_list[["instrument_item.csv"]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(instrument_item_id="integer", instrument_id= "integer", name="character varying (20)",
                                        description="text", instrument_item_type_concept_id="bigint",
                                        instrument_item_concept_vocabulary= "character varying (20)",
                                        instrument_item_concept_vocabulary_id="integer",
                                        alternative_instrument_item_concept_vocabulary= "character varying (20)",
                                        alternative_instrument_item_concept_vocabulary_id="bigint", 
                                        result_not_null_answer_list_concept_vocabulary="character varying (20)"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.instrument_item ADD PRIMARY KEY (instrument_item_id);
                                                          ")
                     )
    
  }
  
  ## instrument metadata
  load_instrument_metadata <- if (data_exists[["instrument"]]$case == 1) {
    print("Metadata exists in instrument table")
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "instrument")
                      , value = df_list[["instrument.csv"]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(instrument_id="integer", name= "text", description="text",
                                        instrument_type_concept_id="bigint", 
                                        version="double precision",
                                        version_date= "date",
                                        language_concept_id="integer"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.instrument ADD PRIMARY KEY (instrument_id);
                                                          ")
                     )
    
  }
  
  ## methodology metadata
  load_methodology_metadata <- if (data_exists[["methodology"]]$case == 1) {
    print("Metadata exists in methodology table")
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "methodology")
                      , value = df_list[["methodology.csv"]]
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(methodology_id="integer", 
                                        data_collection_methodology_description= "character varying (255)",
                                        data_collection_methodology_type="character varying (255)",
                                        time_method_description="character varying (255)", 
                                        time_method_type="character varying (255)",
                                        sampling_procedure_description= "character varying (255)",
                                        sampling_procedure_type="character varying (255)",
                                        data_collection_software_name="character varying (255)",
                                        data_collection_software_version="character varying (255)",
                                        data_collection_software_package_type="character varying (255)",
                                        quality_statement_standard_name="character varying (255)",
                                        quality_statement_standard_description="character varying (255)",
                                        population_study_id="integer"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.methodology ADD PRIMARY KEY (methodology_id);
                                                          ")
                     )
    
  }
  
  ## population study metadata
  load_population_study_metadata <- if (data_exists[["population_study"]]$case == 1) {
    print("Metadata exists in population study table")
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "population_study"
                                  )
                      , value = df_list[["population_study.csv"]] %>%
                        dplyr::mutate(across(c(version_date), ~lubridate::dmy(.x))
                                      )
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(name="character varying", description= "text", country="text", abstract="text", 
                                        phenotype_description="text", outcome_phenotype_description= "text",
                                        covariates_description="text", analyses_supported_text="text", 
                                        version="double precision", version_date= "date", citation_creators="text",
                                        citation_contributors="text", `universe_spatial_coverage_text text`="text",
                                        population_study_id = "integer", doi_registry= "text", doi_value="text",
                                        url="text", citation_title="text", citation_publisher= "text",
                                        citation_language_concept_id="double precision",
                                        keywords="text", universe_spatial_coverage_concept_id="text",
                                        universe_temporal_coverage= "text", analyses_supported_concept_id="double precision",
                                        data_source="character varying (50)"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.population_study ADD PRIMARY KEY (population_study_id);
                                                          ")
                     )
    
  }
  
  ## wave metadata
  load_wave_metadata <- if (data_exists[["wave"]]$case == 1) {
    print("Metadata exists in wave table")
  } else {
    
    DBI::dbWriteTable(con
                      , name = Id(schema = nn, table = "wave")
                      , value = df_list[["wave.csv"]] %>%
                        dplyr::mutate(across(c(start_date, end_date), ~lubridate::dmy(.x))
                                      )
                      , overwrite = TRUE
                      , row.names = FALSE
                      , field.types = c(wave_id="integer", name= "character varying (50)", description="text",
                                        instrument_model_type_concept_id="bigint",
                                        start_date="date", end_date="date", kind_of_data_concept_id="integer",
                                        authorizing_agency_concept_id="integer",
                                        authorizing_statement= "text",
                                        population_study_id="integer"
                                        )
                      )
    
    DBI::dbSendQuery(con, glue::glue("
    ALTER TABLE {nn}.wave ADD PRIMARY KEY (wave_id);
                                                          ")
                     )
    
  }
  
}, simplify = FALSE
)

