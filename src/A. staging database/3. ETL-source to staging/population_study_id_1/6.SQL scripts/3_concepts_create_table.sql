SET search_path TO mh_staging;

show search_path;

---Creating ppd table
CREATE TABLE IF NOT EXISTS "staging-dataset".concepts_data 
( 
inspire_concept_id FLOAT,
concept_id FLOAT,
concept_vocabulary VARCHAR,
concept_code VARCHAR,
concept_text VARCHAR,
score VARCHAR,
start_date VARCHAR,
end_date VARCHAR
)

SELECT * FROM "staging-dataset".concepts_data;
--DROP TABLE IF EXISTS "staging-dataset".concepts_data;

