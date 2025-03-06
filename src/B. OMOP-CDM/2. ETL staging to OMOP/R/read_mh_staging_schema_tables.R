library(RPostgres)
library(DBI)

working_directory


## Set the search path to the staging schema

dbExecute(con, sprintf("SET search_path TO %s", staging_schema_name))

list_staging_tables <- DBI::dbListTables(con)

#list_staging_tables <- DBI::dbListObjects(con, DBI::Id(schema = staging_schema_name))

## Read tables in selected scheme
staging_tables_data <- sapply(list_staging_tables, function(x){
  nn <- x
  
  read_tables <- DBI::dbReadTable(con, nn)
  
}, simplify = FALSE
)

list_population_studies <- unique(staging_tables_data[["longitudinal_population_study_fact"]]$population_study_id)

