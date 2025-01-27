SET search_path TO mh_staging;

show search_path;

--CTE 
---max row household characteristics number 22860
---max row household number 7567
WITH max_id AS(
	SELECT 
	max(household_characteristics_id) AS max_household_characteristics_id
			   FROM mh_staging_1_1.household_characteristics
),
household_characteristics_ppd (ssid, wave_id, household_characteristics_concept_id) AS(
	SELECT ssid AS ssid,
	       1 AS wave_id,
	       CASE
            WHEN hsld < 2 THEN 3000000212
            WHEN hsld < 5 THEN 3000000213
            WHEN hsld < 10 THEN 3000000214
            WHEN hsld < 15 THEN 3000000215
	        WHEN hsld >= 15 THEN 3000000216
	        ELSE 0
        END AS household_characteristics_concept_id
	FROM "secondary-data".ppd_data
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       2 AS wave_id,
	       CASE
            WHEN hsld < 2 THEN 3000000212
            WHEN hsld < 5 THEN 3000000213
            WHEN hsld < 10 THEN 3000000214
            WHEN hsld < 15 THEN 3000000215
	        WHEN hsld >= 15 THEN 3000000216
	        ELSE 0
        END AS household_characteristics_concept_id
	FROM "secondary-data".ppd_data
	WHERE id2 IS NOT NULL
	
	ORDER BY ssid ASC, wave_id ASC
	
)

INSERT INTO mh_staging_1_1.household_characteristics(
	household_characteristics_id,
    household_id,
    wave_id,
    household_characteristics_concept_id,
    household_characteristics_concept_text
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_household_characteristics_id AS household_characteristics_id,
mh_staging_1_1.household.household_id AS household_id,
household_characteristics_ppd.wave_id AS wave_id,
household_characteristics_ppd.household_characteristics_concept_id AS household_characteristics_concept_id,
mh_staging_1_1.concept.concept_text AS household_characteristics_concept_text
FROM max_id, household_characteristics_ppd
INNER JOIN mh_staging_1_1.household
	ON mh_staging_1_1.household.household_id_value = household_characteristics_ppd.ssid
LEFT JOIN mh_staging_1_1.concept
	ON mh_staging_1_1.concept.concept_id = household_characteristics_ppd.household_characteristics_concept_id
	
--- Error solving

DELETE FROM mh_staging_1_1.household_characteristics
WHERE household_characteristics_id > 22860;

---Checking accuracy of entry

SELECT * FROM mh_staging_1_1.household_characteristics
WHERE household_characteristics_id > 22860

