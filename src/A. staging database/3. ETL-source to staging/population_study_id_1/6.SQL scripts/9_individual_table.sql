SET search_path TO mh_staging;

show search_path;

--CTE 
---max row individual number 9067
---max row household number 7567
WITH max_id AS(
	SELECT 
	max(individual_id) AS max_individual_id
			   FROM mh_staging_1_1.individual
)
--SELECT * FROM max_id

INSERT INTO mh_staging_1_1.individual(
	individual_id,
	individual_id_value,
    household_id,
    gender_concept_id,
    first_wave_id,
    age_at_first_wave,
	year_of_birth,
	is_household_head
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_individual_id AS individual_id,
ssid AS individual_id_value,
mh_staging_1_1.household.household_id AS household_id,
8532 AS gender_concept_id,
1 AS first_wave_id,
ROUND(CAST(age AS numeric),0) AS age_at_first_wave,
DATE_PART ('year', new_birth_date) AS year_of_birth,
'false' AS is_household_head
FROM max_id, (SELECT *,
	  CAST (ydob1 AS DATE) AS new_birth_date
	  FROM "secondary-data".ppd_data
	 ) AS derivedtable 
	 INNER JOIN mh_staging_1_1.household
	ON mh_staging_1_1.household.household_id_value = derivedtable.ssid
	
--- Error solving

DELETE FROM mh_staging_1_1.individual
WHERE individual_id > 9067;

---Checking accuracy of entry

SELECT * FROM mh_staging_1_1.individual
WHERE individual_id > 9067

