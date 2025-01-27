SET search_path TO mh_staging;

show search_path;

TRUNCATE TABLE "staging-dataset".concepts_data;

SET client_encoding = WIN1252;

---Insert data to concepts_data
COPY "staging-dataset".concepts_data (
inspire_concept_id,
concept_id,
concept_vocabulary,
concept_code,
concept_text,
score,
start_date,
end_date
)
FROM 'path\to\6.SQL scripts\concepts_table.csv'
DELIMITER ',' 
CSV HEADER
NULL '';

SET client_encoding TO 'UTF8';
SELECT * FROM "staging-dataset".concepts_data;

--DELETE FROM "staging-dataset".concepts_data;
--TRUNCATE TABLE "staging-dataset".concepts_data;
