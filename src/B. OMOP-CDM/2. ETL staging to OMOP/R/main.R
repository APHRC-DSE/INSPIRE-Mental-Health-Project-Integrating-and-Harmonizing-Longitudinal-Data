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
#staging_schema_name <- "mh_staging_1_1" #study 12, 1
#staging_schema_name <- "mh_staging_1_1_dev_old" #study 12, 1, 5, 2, 3
staging_schema_name <- "mh_staging_1_1_dev_old_new" #study 12, 1, 5, 2, 3, 7, 8, 9, 10, 11

### updating staging metadata tables
source("empty_staging_metadata_tables.R")
source("load_staging_metadata_tables.R")

######################################################################

### Loading and saving staging database schema in Postgres to environment
source("read_mh_staging_schema_tables.R")

### Create OMOP-CDM Schemas for individual studies, single vocabulary and list all schemas
source("create_cdm_vocab_results_schema.R")

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

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_7_cdm_r"), "results_study_7_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_8_cdm_r"), "results_study_8_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_9_cdm_r"), "results_study_9_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_10_cdm_r"), "results_study_10_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_11_cdm_r"), "results_study_11_cdm_r.json"))

DataQualityDashboard::viewDqDashboard(base::file.path(base::file.path(DQD_Dir, "study_12_cdm_r"), "results_study_12_cdm_r.json"))


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

