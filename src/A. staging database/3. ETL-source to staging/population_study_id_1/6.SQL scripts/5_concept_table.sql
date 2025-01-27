SET search_path TO mh_staging;

show search_path;

TRUNCATE TABLE mh_staging_1_1.concept;

INSERT INTO mh_staging_1_1.concept(
	concept_vocabulary,
    concept_code,
	concept_text,
	start_date,
	end_date,
	inspire_concept_id,
	concept_id,
	score
)
SELECT
concept_vocabulary AS concept_vocabulary,
concept_code AS concept_code,
concept_text AS concept_text,
TO_DATE(start_date, 'DD-Mon-YYYY') AS start_date,
TO_DATE(end_date, 'DD-Mon-YYYY') AS end_date,
inspire_concept_id AS inspire_concept_id,
concept_id AS concept_id,
score AS score
FROM "staging-dataset".concepts_data;
	
--- Error solving
DELETE FROM mh_staging_1_1.concept;

---Checking accuracy of entry
SELECT * FROM mh_staging_1_1.concept;

