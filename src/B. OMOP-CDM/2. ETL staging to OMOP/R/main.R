######################################################################
### Restart R
#.rs.restartR()

### Start with a clean environment by removing objects in workspace
rm(list=ls())

### Setting work directory
working_directory <- base::setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#working_directory <- base::setwd(".")

### Load Rdata
Rdata_files <- list.files(path = working_directory, pattern = "*.RData", full.names = T)

if ( length(Rdata_files) >0) {
  invisible(lapply(Rdata_files,load,.GlobalEnv))
} else {
  paste(c(".RData files", "do not exist"), collapse = " ")
}

### Install required packages
source("requirements.R")

######################################################################
## Connecting to local database using DBI package

#file.edit("~/.Renviron") store password credentials for postgres in .Renviron and retrieve with Sys.getenv()
#usethis::edit_r_environ()
#restart R

database_name <- "mh_staging"

con <- dbConnect(drv = RPostgres::Postgres(),
                 dbname = database_name, 
                 host = 'localhost', 
                 port = 5432, 
                 user = 'postgres',
                 password = Sys.getenv("postgres_password")
                 #password = rstudioapi::askForPassword("Database password")
                 )

print(con)

######################################################################
## Local Database
#staging_schema_name <- "mh_staging_1_1" #study 12 w1, 1
#staging_schema_name <- "mh_staging_1_1_dev_old" #study 12 w1, 1, 5, 2, 3
#staging_schema_name <- "mh_staging_1_1_dev_old_new" #study 12 w1, 1, 5, 2, 3, 7, 8, 9, 10, 11
#staging_schema_name <- "mh_staging_1_1_dev_march" #study 12 w1, 1, 5, 2, 3, 7, 8, 9, 10, 11, 14
staging_schema_name <- "mh_staging_1_1_dev_april" #study 12 w1 w2, 1, 5, 2, 3, 7, 8, 9, 10, 11, 14, 6, 13 #ignore 13 and 14

### updating staging metadata tables
source("empty_staging_metadata_tables.R")
source("load_staging_metadata_tables.R")

######################################################################

### Loading and saving staging database schema in Postgres to environment
source("read_mh_staging_schema_tables.R")

list_population_studies_raw <- unique(staging_tables_data[["longitudinal_population_study_fact"]]$population_study_id)

list_population_studies <- list_population_studies_raw[!list_population_studies_raw %in% c(13, 14)]

######################################################################

### Create OMOP-CDM Schemas for individual studies, single vocabulary and list all schemas
source("create_cdm_vocab_results_schema.R")

######################################################################

#List all schemas after each study schema have been created 
list_all_schemas_cdm <- dbGetQuery(con, "SELECT schema_name FROM information_schema.schemata") #output is df

#List lps tables based on staging schema version adding vocabulary schema
list_tables_study_lps <- paste(c(paste0("study_", as.numeric(list_population_studies), "_cdm_r"), "vocabulary"))

#List all schemas with changing staging schema version
list_all_schemas_study_cdm <- list_all_schemas_cdm %>%
  dplyr::filter(schema_name %in% list_tables_study_lps)

######################################################################

### create OMOPCDM_5.4_ddl tables, Primary key, foreign keys and indexing
source("create_cdm_tables_rpackage.R")

######################################################################
## Loading vocabularies in vocabulary schema
#source("empty_omop_vocabs.R") #Uncomment and Run this if you want to reload vocabularies
source("load_omop_vocabs.R")

######################################################################
## Transforming data from Staging and loading to OMOP-CDM

### location table
source("location_staging_to_omop.R")

### Caresite table
source("caresite_staging_to_omop.R")

### Provider table
source("provider_staging_to_omop.R")

### Person table
source("person_staging_to_omop.R")

### Visit occurrence table
source("visit_occurrence_staging_to_omop.R")

### Visit detail table
source("visit_detail_staging_to_omop.R")

### Observation period table
source("observation_period_staging_to_omop.R")

### Measurement table
source("measurement_staging_to_omop.R")

### Observation table
source("observation_staging_to_omop.R")

### Condition Occurence table
source("condition_occurrence_staging_to_omop.R")

### Condition Era table
source("condition_era_staging_to_omop.R")

### CDM Source table
source("cdm_source_staging_to_omop.R")

######################################################################
## Disconnecting from database
DBI::dbDisconnect(con)

######################################################################
## Achilles 
source("achilles_analysis.R")

######################################################################
## Data Quality Dashboard 
source("data_quality_dashboard.R")

#INSPECT LOGS

ParallelLogger::launchLogViewer(
  logFileName = base::file.path(base::file.path(DQD_Dir, "study_1_cdm_r"), 
                                paste0("log_DqDashboard_",cdm_source_cdm_table[["study_1_cdm_r"]]$cdm_source_abbreviation, ".txt")
                                )
  )

ParallelLogger::launchLogViewer(
  logFileName = base::file.path(base::file.path(DQD_Dir, "study_12_cdm_r"),  
                                paste0("log_DqDashboard_",cdm_source_cdm_table[["study_12_cdm_r"]]$cdm_source_abbreviation, ".txt"))
  )

#VIEW RESULTS
#Launching Dashboard as Shiny App

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_1_cdm_r"), "results_study_1_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_2_cdm_r"), "results_study_2_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_3_cdm_r"), "results_study_3_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_5_cdm_r"), "results_study_5_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_6_cdm_r"), "results_study_6_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_7_cdm_r"), "results_study_7_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_8_cdm_r"), "results_study_8_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_9_cdm_r"), "results_study_9_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_10_cdm_r"), "results_study_10_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_11_cdm_r"), "results_study_11_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_12_cdm_r"), "results_study_12_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_14_cdm_r"), "results_study_14_cdm_r.json"))

######################################################################

## Save workspace at the end without working directory path

save(list = ls(all.names = TRUE)[!ls(all.names = TRUE) %in% c("working_directory", "mainDir", "subDir_output", "output_Dir",
                                                              "subDir_data", "data_Dir", "con", "Rdata_files", "DQD_Dir",
                                                              "Achilles_Analysis_Dir", "executeDDL_Error_Dir"
                                                              )],
     file = "staging_db_to_omop.RData",
     envir = .GlobalEnv #parent.frame()
     ) 

#save.image(file = "staging_db_to_omop.RData")

######################################################################

## Run all files in Rstudio
source("main.R")

######################################################################
