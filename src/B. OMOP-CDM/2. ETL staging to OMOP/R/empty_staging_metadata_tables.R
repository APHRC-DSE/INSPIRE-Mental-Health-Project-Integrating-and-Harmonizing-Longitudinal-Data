library(RPostgres)
library(DBI)
library(glue)

working_directory

# Empty data in Staging Metadata Tables

#List all schemas in database 
list_all_schemas_metadata <- DBI::dbGetQuery(con, "SELECT schema_name FROM information_schema.schemata") #output is df

empty_staging_metadata <- sapply(list_all_schemas_metadata$schema_name[grepl("^mh_staging_1_", list_all_schemas_metadata$schema_name)], function(x){
  nn <- x
  
  query_set_search_path <- DBI::dbExecute(con, sprintf("SET search_path TO %s", nn))
  
  #Drop Table as it is read only. No primary key was set.
  DBI::dbSendQuery(con, glue::glue("
    DROP TABLE IF EXISTS {nn}.population_study CASCADE;
                                                          ")
                   )
  
  #Create population study Table
  DBI::dbSendQuery(con, glue::glue("
    CREATE TABLE IF NOT EXISTS {nn}.population_study 
    ( 
    name VARCHAR,
    description TEXT,
    country TEXT,
    abstract TEXT,
    phenotype_description TEXT,
    outcome_phenotype_description TEXT,
    covariates_description TEXT,
    analyses_supported_text TEXT,
    version DOUBLE PRECISION,
    version_date DATE,
    citation_creators TEXT,
    citation_contributors TEXT,
    universe_spatial_coverage_text TEXT,
    population_study_id INTEGER PRIMARY KEY,
    doi_registry TEXT,
    doi_value TEXT,
    url TEXT,
    citation_title TEXT,
    citation_publisher TEXT,
    citation_language_concept_id DOUBLE PRECISION,
    keywords TEXT,
    universe_spatial_coverage_concept_id TEXT,
    universe_temporal_coverage TEXT,
    analyses_supported_concept_id DOUBLE PRECISION,
    data_source VARCHAR(50)
    );
                                   ")
  )
  
  #Truncating quickly removes all data from a table while maintaining the table structure and associated constraints.
  
  empty_staging_metadata_tables <- DBI::dbSendQuery(con, glue::glue("
      TRUNCATE TABLE {nn}.concept, {nn}.data_capture_event, {nn}.instrument_item, {nn}.instrument,
      {nn}.methodology, {nn}.population_study, {nn}.wave
      ;")
                                    )
  
}, simplify = FALSE
)



