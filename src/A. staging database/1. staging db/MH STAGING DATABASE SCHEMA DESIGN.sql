/ Standardized Staging Vocabulary Tables
  
  Table "concept" {
    "inspire_concept_id" INT [primary key]
    "concept_id" INT UNIQUE
    "concept_vocabulary" VARCHAR(20) 
    "concept_code" INT 
    "concept_text" TEXT 
    "score"  INT
    "start_date" DATE
    "end_date" DATE
   }

Table "instrument" {
  "instrument_id" INT [PRIMARY KEY]
  "name"   VARCHAR (20)
  "description" TEXT
  "instrument_type_concept_id" INT [ref: > concept.concept_id]
  "version"  FLOAT
  "version_date"  DATE
  "language_concept_id"  INT
}

Table "instrument_item" {
  "instrument_item_id" INT [PRIMARY KEY]
  "instrument_id" INT [ref: > instrument.instrument_id]
  "name"  VARCHAR(20)
  "description" TEXT
  "instrument_item_type_concept_id" INT [ref: > concept.concept_id]
  "instrument_item_concept_vocabulary"  VARCHAR(20)
  "instrument_item_concept_vocabulary_id"  INT
  "alternative_instrument_item_concept_vocabulary"  VARCHAR(20)
  "alternative_instrument_item_concept_vocabulary_id" INT
  "result_not_null_answer_list_concept_vocabulary"  VARCHAR(20)
}

// Standardized Staging Metadata Tables

Table "population_study"{
  "population_study_id" INT [PRIMARY KEY]
  "doi_registry"  VARCHAR (50)
  "doi_value" INT
  "URL" VARCHAR (255)
  "name" varchar
  "description" TEXT
  "country" VARCHAR(50)
  "abstract" TEXT
  "citation_title" VARCHAR (255)
  "citation_creator(s)" VARCHAR(255)
  "citation_publisher" VARCHAR (255)
  "citation_contributor(s)" VARCHAR (255)
  "citation_language_concept_id" INT
  "keywords" VARCHAR (255)
  "universe_spatial_coverage_concept_id" INT
  "universe_spatial_coverage_text" VARCHAR(100)
  "universe_temporal_coverage" VARCHAR (255)
  "target_phenotype_description" TEXT
  "outcome_phenotype_description" TEXT
  "covariates_description" TEXT
  "analyses_supported_concept_id" INT
  "analyses_supported_text" VARCHAR(50)
  "version"  FLOAT
  "version_date"  DATE
}

Table "methodology" {
  "methodology_id" INT [primary key]
  "data_collection_methodology_description"  VARCHAR (255)
  "data_collection_methodology_type"  VARCHAR (255)
  "time_method_description" VARCHAR(255)
  "time_method_type" VARCHAR(255)
  "sampling_procedure_description"  VARCHAR(255)
  "sampling_procedure_type"  VARCHAR(255)
  "data_collection_software_name"  VARCHAR(255)
  "data_collection_software_version"  VARCHAR(255)
  "data_collection_software_package_type"  VARCHAR(255)
  "quality_statement_standard_name"  VARCHAR(255) 
  "quality_statement_standard_description"  VARCHAR(255)
  "population_study_id" INT [ref: > population_study.population_study_id]
}

Table "wave" {
  "wave_id" INT [PRIMARY KEY]
  "name"  VARCHAR (50)
  "description" TEXT
  "instrument_model_type_concept_id" INT
  "start_date"  DATE
  "end_date"  DATE
  "kind_of_data_concept_id"  INT
  "authorizing_agency_concept_id" INT
  "authorizing_statement" TEXT
  "population_study_id" INT [ref: > population_study.population_study_id]
}

Table "data_capture_event" {
  "data_capture_id" INT [primary key]
  "wave_id" INT [ref: > wave.wave_id]
  "instrument_id" INT [ref: > instrument.instrument_id]
  "completion_status"  VARCHAR(20)
  "data_quality_indicator"  VARCHAR(255)
  "mode_of_collection_description"  VARCHAR(255)
  "mode_of_collection_type"  VARCHAR(255)
  "data_capture_collector"  VARCHAR(255)
  "data_source_description"  VARCHAR(255)
  "data_source_type"  VARCHAR(255)
  "data_capture_event_date"  DATE
  }


// Standardized Staging MH Person Tables

Table "individual" {
    "individual_id" INT [primary key]
    "individual_id_value" VARCHAR(20)
    "household_id" INT [ref: > household.household_id]
    "gender_concept_id" INT [ref: > concept.concept_id] 
    "first_wave_id" INT
    "age_at_first_wave" INT
    "year_of_birth" INT
    "is_household_head" BOOL
   }

// The individual_demographics table will capture
// education, religion, race etc.
   Table "individual_demographics" {
    "individual_demographics_id" INT [primary key]
    "individual_id" INT [ref: > individual.individual_id]
    "individual_concept_id" INT [ref: > concept.concept_id]
    "individual_concept_id_text" VARCHAR(100)
   }

   Table "location" {
    "location_id" INT [primary key]
    "village_name" VARCHAR(19) 
    "place_kind"  VARCHAR(10) 
    "latitude" FLOAT
    "longitude" FLOAT
   }

   Table "household" {
    "household_id" INT [primary key]
    "household_id_value" VARCHAR(20)
    "location_id" INT [ref: > location.location_id]
    "household_head_id" INT [ref: > individual.individual_id]
  }

// The household_charactertitics table will store
// houselevel information like wealth, income source, etc.
  Table "household_characteristics" {
    "household_characteristics_id" INT [primary key]
    "household_id" INT [ref: > household.household_id]
    "wave_id" INT [ref: > wave.wave_id]
    "household_characteristics_concept_id" INT [ref: > concept.concept_id]
    "household_characteristics_concept_text" VARCHAR(100)
   }


   Table "resident_episode" {
    "resident_episode_id" INT [primary key]
    "location_id" INT [ref: > location.location_id]
    "household_id" INT  [ref: > household.household_id]
    "wave_id" INT [ref: > wave.wave_id]
   }

  Table "interview" {
    "interview_id" INT [primary key]
    "individual_id" INT [ref: > individual.individual_id]
    "interview_date" DATE 
    "wave_id" INT [ref: > wave.wave_id]
    "instrument_id" INT [ref: > instrument.instrument_id]
  }
// Standardized Staging FACT Table

Table "longitudinal_population_study_fact" {
  "longitudinal_population_study_fact_id" INT [PRIMARY KEY]
  "individual_id" INT [ref: > individual.individual_id] 
  "interview_id" INT [ref: > interview.interview_id]
  "resident_episode_id" INT [ref: > resident_episode.resident_episode_id]
  "population_study_id" INT [ref: > population_study.population_study_id]
  "instrument_id" INT [ref: > instrument.instrument_id]
  "instrument_item_id" INT [ref: > instrument_item.instrument_item_id]
  "concept_id" INT [ref: > concept.concept_id]
  "value_type_concept_id" INT
  "value_as_char" VARCHAR
  "value_as_num" INT
  "value_as_concept" INT [ref: > concept.inspire_concept_id]
}
