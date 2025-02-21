SET search_path TO "put database name here";

show search_path;

---Truncating quickly removes all data from a table while maintaining the table structure and associated constraints.
TRUNCATE TABLE "put schema name here".concept, "put schema name here".data_capture_event, "put schema name here".instrument_item,
 "put schema name here".instrument, "put schema name here".methodology, "put schema name here".population_study, "put schema name here".wave;


--- Add column to population study table and concept table

ALTER TABLE "put schema name here".population_study ADD COLUMN IF NOT EXISTS data_source VARCHAR(50);

ALTER TABLE "put schema name here".concept ADD COLUMN IF NOT EXISTS domain TEXT;

---Insert data to concept table
SET client_encoding = WIN1252;

COPY "put schema name here".concept (
concept_vocabulary,
concept_code,
concept_text,
start_date,
end_date,
inspire_concept_id,
concept_id,
score,
domain
)
FROM 'folder path\concept.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SET client_encoding TO 'UTF8';
SELECT * FROM "put schema name here".concept;

---Insert data to data_capture_event table

COPY "put schema name here".data_capture_event (
data_capture_id,
wave_id,
instrument_id,
completion_status,
data_quality_indicator,
mode_of_collection_description,
mode_of_collection_type,
data_capture_collector,
data_source_description,
data_source_type,
data_capture_event_date
)
FROM 'folder path\data_capture_event.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".data_capture_event;

---Insert data to instrument_item table

COPY "put schema name here".instrument_item (
instrument_item_id,
instrument_id,
name,
description,
instrument_item_type_concept_id,
instrument_item_concept_vocabulary,
instrument_item_concept_vocabulary_id,
alternative_instrument_item_concept_vocabulary,
alternative_instrument_item_concept_vocabulary_id,
result_not_null_answer_list_concept_vocabulary
)
FROM 'folder path\instrument_item.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".instrument_item;

---Insert data to instrument table

COPY "put schema name here".instrument (
instrument_id,
name,
description,
instrument_type_concept_id,
version,
version_date,
language_concept_id
)
FROM 'folder path\instrument.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".instrument;

---Insert data to methodology table

COPY "put schema name here".methodology (
methodology_id,
data_collection_methodology_description,
data_collection_methodology_type,
time_method_description,
time_method_type,
sampling_procedure_description,
sampling_procedure_type,
data_collection_software_name,
data_collection_software_version,
data_collection_software_package_type,
quality_statement_standard_name,
quality_statement_standard_description,
population_study_id
)
FROM 'folder path\methodology.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".methodology;

---Insert data to population_study table

COPY "put schema name here".population_study (
name,
description,
country,
abstract,
phenotype_description,
outcome_phenotype_description,
covariates_description,
analyses_supported_text,
version,
version_date,
citation_creators,
citation_contributors,
universe_spatial_coverage_text text,
population_study_id,
doi_registry,
doi_value,
url,
citation_title,
citation_publisher,
citation_language_concept_id,
keywords,
universe_spatial_coverage_concept_id,
universe_temporal_coverage,
analyses_supported_concept_id,
data_source
)
FROM 'folder path\population_study.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".population_study;

---Insert data to wave table

COPY "put schema name here".wave (
wave_id,
name,
description,
instrument_model_type_concept_id,
start_date,
end_date,
kind_of_data_concept_id,
authorizing_agency_concept_id,
authorizing_statement,
population_study_id
)
FROM 'folder path\wave.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SELECT * FROM "put schema name here".wave;
