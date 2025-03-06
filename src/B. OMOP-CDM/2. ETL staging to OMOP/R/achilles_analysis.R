library(DatabaseConnector)
library(Achilles)

working_directory

#Automated Characterization of Health Information at Large-Scale Longitudinal Evidence Systems (ACHILLES) 
## Achilles provides descriptive statistics on an OMOP CDM database. ACHILLES currently supports CDM version 5.3 and 5.4.


### Run Achilles
achilles_analysis <- sapply(list_all_schemas_study_cdm$schema_name[grepl("^study_", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x

  results_schema <- paste0("results_", nn)
  
  vocabulary_schema <- "vocabulary"
  
  source_name <- cdm_source_cdm_table[[nn]]$cdm_source_abbreviation
  
  output_folder <- base::file.path(Achilles_Analysis_Dir, nn) #create output folder for individual studies
  
  #Add the default error report logger
  #ParallelLogger::addDefaultErrorReportLogger(file.path(output_folder, "errorReportSql.txt"))
  
  options(rstudio.connectionObserver.errorsSuppressed = TRUE)
  
  cd <- DatabaseConnector::createConnectionDetails(
    dbms = "postgresql",
    server = paste0("localhost","/",database_name),
    user = "postgres",
    password = Sys.getenv("postgres_password"),
    port = 5432,
    pathToDriver = base::file.path(data_Dir, "JDBC Driver postgresql")
    )
  
  #run achilles
  Achilles::achilles(connectionDetails = cd,
                     cdmDatabaseSchema = nn,
                     resultsDatabaseSchema = results_schema,  #no capital letters- brings issues with postgres
                     vocabDatabaseSchema = vocabulary_schema,
                     sourceName = source_name,
                     createTable = TRUE,
                     smallCellCount = 5,
                     cdmVersion = "5.4",
                     createIndices = TRUE,
                     numThreads = 1,
                     outputFolder = output_folder,
                     optimizeAtlasCache = FALSE
                     )
  
  
}, simplify = FALSE
)

