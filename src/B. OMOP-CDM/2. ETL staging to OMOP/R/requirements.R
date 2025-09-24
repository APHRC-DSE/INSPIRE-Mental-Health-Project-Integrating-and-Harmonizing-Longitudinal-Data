## Setting working directory and output folder

working_directory

mainDir <- base::getwd()
subDir_data <- "data"
subDir_output <- "Output"


data_Dir <- base::file.path(mainDir, subDir_data)
output_Dir <- base::file.path(mainDir, subDir_output)


### create data folder
base::ifelse(!base::dir.exists(data_Dir), base::dir.create(data_Dir), "Sub Directory exists")

### create output folders
base::ifelse(!base::dir.exists(output_Dir), base::dir.create(output_Dir), "Sub Directory exists")

### create Output folder for DDL Error file
executeDDL_Error_Dir <- base::file.path(output_Dir, "executeDDL_Error")

base::ifelse(!base::dir.exists(executeDDL_Error_Dir), base::dir.create(executeDDL_Error_Dir),
             "executeDDL Error Sub Directory exists"
             )

### create Output folder for Achilles Analysis
Achilles_Analysis_Dir <- base::file.path(output_Dir, "Achilles Analysis")

base::ifelse(!base::dir.exists(Achilles_Analysis_Dir), base::dir.create(Achilles_Analysis_Dir),
             "Achilles Analysis Sub Directory exists"
             )

### create Output folder for DQD
DQD_Dir <- base::file.path(output_Dir, "Data Quality Dashboard")

base::ifelse(!base::dir.exists(DQD_Dir), base::dir.create(DQD_Dir),
             "Data Quality Dashboard Sub Directory exists"
             )

## Install required packages

### Install CRAN packages
required_packages <- c("RPostgres", "DBI", "tidyverse", "lubridate", "tibble", "scales", "devtools",
                       "DatabaseConnector", "glue", "remotes", "glue"
                       )

installed_packages <- required_packages %in% base::rownames(utils::installed.packages())

if (base::any(installed_packages==FALSE)) {
  utils::install.packages(required_packages[!installed_packages]
                          #, repos = "http://cran.us.r-project.org"
                          )
}

### load CRAN libraries
base::invisible(base::lapply(required_packages, library, character.only=TRUE))

### development packages
required_dev_packages <- c("OHDSI/CommonDataModel", "OHDSI/DataQualityDashboard", "OHDSI/Achilles")
required_dev_name_packages <- stringr::str_extract(required_dev_packages, '\\b[^/]+$')

installed_dev_packages <- required_dev_name_packages %in% base::rownames(utils::installed.packages())

if (base::any(installed_dev_packages==FALSE)) {
  remotes::install_github(required_dev_packages[!installed_dev_packages])
} 


### load development libraries
base::invisible(base::lapply(required_dev_name_packages, library, character.only=TRUE))

