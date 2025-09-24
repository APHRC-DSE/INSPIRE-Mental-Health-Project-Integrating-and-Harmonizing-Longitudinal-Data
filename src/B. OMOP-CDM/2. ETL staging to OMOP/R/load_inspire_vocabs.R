library(RPostgres)
library(DBI)
library(glue)

working_directory

# Loading Vocabularies in OMOP CDM Tables

load_inspire_vocabs <- sapply(list_all_schemas_study_cdm$schema_name[grepl("vocabulary", list_all_schemas_study_cdm$schema_name)], function(x){
  nn <- x
  
  #Set path to your downloaded and unzipped Vocabularies from Athena
  inspire_concept_path <- glue::glue(gsub("/", "\\\\", data_Dir), "\\inspire_concepts_OMOP.csv")
  
  inspire_ancestor_path <- glue::glue(gsub("/", "\\\\", data_Dir), "\\inspire_concept_ancestor.csv")
  
  inspire_vocabulary_path <- glue::glue(gsub("/", "\\\\", data_Dir), "\\inspire_concept_vocabulary.csv")
  
  inspire_synonym_path <- glue::glue(gsub("/", "\\\\", data_Dir), "\\inspire_concept_synonym.csv")
  
  inspire_relationship_path <- glue::glue(gsub("/", "\\\\", data_Dir), "\\inspire_concept_relationship.csv")
  
  query_set_search_path <- DBI::dbExecute(con, sprintf("SET search_path TO %s", nn))
  
  #Alter columns to BIGINT 
  alter_concept_table <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT
      ALTER COLUMN concept_id TYPE BIGINT;
                          ")
                     )
  
  alter_ancestor_table1 <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT_ANCESTOR
      ALTER COLUMN ancestor_concept_id TYPE BIGINT;
                          ")
                     )
  
  alter_ancestor_table2 <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT_ANCESTOR
      ALTER COLUMN descendant_concept_id TYPE BIGINT;
                          ")
                     )
  
  alter_synonym_table <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT_SYNONYM
      ALTER COLUMN concept_id TYPE BIGINT;
                          ")
                     )
  
  alter_relationship_table1 <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT_RELATIONSHIP
      ALTER COLUMN concept_id_1 TYPE BIGINT;
                          ")
                     )
  
  alter_relationship_table2 <- 
    DBI::dbSendQuery(con, glue::glue("
      ALTER TABLE {nn}.CONCEPT_RELATIONSHIP
      ALTER COLUMN concept_id_2 TYPE BIGINT;
                          ")
                     )
  
  #vocabulary metadata entry
  #vocabulary_id must exist in the vocabulary table. If it doesn’t, ATLAS won’t index or show your concepts
  
  load_vocabulary_table <- 
    DBI::dbSendQuery(con, glue::glue("
      COPY {nn}.VOCABULARY FROM '{inspire_vocabulary_path}'
      DELIMITER ',' 
      CSV HEADER 
      NULL '';")
                     )
  
  #ATLAS depends on concept_ancestor for hierarchy navigation.
  # local concepts must have entries here to show in hierarchy tree or concept search. 
  #local concepts don’t have parents or children, you can add a self-link
  
  load_ancestor_table <- 
    DBI::dbSendQuery(con, glue::glue("
      COPY {nn}.CONCEPT_ANCESTOR FROM '{inspire_ancestor_path}'
      DELIMITER ',' 
      CSV HEADER 
      NULL '';")
                     )
  
  load_synonym_table <- 
    DBI::dbSendQuery(con, glue::glue("
      COPY {nn}.CONCEPT_SYNONYM FROM '{inspire_synonym_path}'
      DELIMITER ',' 
      CSV HEADER 
      NULL '';")
                     )
  
  DBI::dbSendQuery(con, glue::glue("SET datestyle = dmy;"))
  
  load_concept_table <- 
      DBI::dbSendQuery(con, glue::glue("
      COPY {nn}.CONCEPT FROM '{inspire_concept_path}'
      DELIMITER ',' 
      CSV HEADER 
      NULL '';")
                  )
  
  load_relationship_table <- 
      DBI::dbSendQuery(con, glue::glue("
      COPY {nn}.CONCEPT_RELATIONSHIP FROM '{inspire_relationship_path}'
      DELIMITER ',' 
      CSV HEADER 
      NULL '';")
                  )
  
  DBI::dbSendQuery(con, glue::glue('SET datestyle = "ISO, YMD";'))
  
  
}, simplify = FALSE
)





