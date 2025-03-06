library(RPostgres)
library(DBI)

working_directory


# Create a new schema for each study
create_cdm_schema_name <- sapply(as.numeric(list_population_studies), function(x){
  nn <- x
  name <- paste0("study_", nn, "_cdm_r")
  
  # Create a new schema
  query <- paste0("CREATE SCHEMA IF NOT EXISTS ", name, ";")
  
  # Execute the query
  out <- dbExecute(con, query)
  
  
}, simplify = FALSE
)

# Create results schema for each study
create_results_schema_name <- sapply(as.numeric(list_population_studies), function(x){
  nn <- x
  name <- paste0("results_study_", nn, "_cdm_r")
  
  # Create a new schema
  query <- paste0("CREATE SCHEMA IF NOT EXISTS ", name, ";")
  
  # Execute the query
  out <- dbExecute(con, query)
  
  
}, simplify = FALSE
)

#Create a single vocabulary schema
create_vocabulary_schema_name <- dbExecute(con, paste0("CREATE SCHEMA IF NOT EXISTS vocabulary;")
                                           )

#List all schemas after each study schema have been created 
list_all_schemas_cdm <- dbGetQuery(con, "SELECT schema_name FROM information_schema.schemata") #output is df

#List lps tables based on staging schema version adding vocabulary schema
list_tables_study_lps <- paste(c(paste0("study_", as.numeric(list_population_studies), "_cdm_r"), "vocabulary"))

#List all schemas with changing staging schema version
list_all_schemas_study_cdm <- list_all_schemas_cdm %>%
  dplyr::filter(schema_name %in% list_tables_study_lps)
  
