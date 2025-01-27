SET search_path TO mh_staging;

show search_path;

--CTE 
---max row individual demographics number 45335
---max row household number 9067
WITH max_id AS(
	SELECT 
	max(individual_demographics_id) AS max_individual_demographics_id
			   FROM mh_staging_1_1.individual_demographics
),
individual_demographics_ppd (ssid, individual_concept_id, pos) AS(
	SELECT ssid AS ssid,
	       38003564 AS individual_concept_id,
	       1 AS pos
	FROM "secondary-data".ppd_data
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       38003600 AS individual_concept_id,
		   2 AS pos
	FROM "secondary-data".ppd_data
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       CASE
            WHEN rlg = 'Protestant' THEN 4183092
            WHEN rlg = 'Catholic' THEN 4175384
            WHEN rlg = 'Others (specified)' THEN 3000000188
	        ELSE 0
        END AS individual_concept_id,
	       3 AS pos
	FROM "secondary-data".ppd_data
	WHERE rlg IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       CASE
            WHEN mrtl = 'Never Married' THEN 45881671
            WHEN mrtl = 'Married' THEN 45876756
            WHEN mrtl = 'Separated' THEN 45884459
	        ELSE 0
        END AS individual_concept_id,
	       4 AS pos
	FROM "secondary-data".ppd_data
	WHERE mrtl IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       CASE
            WHEN edc = 'Tertiary (college/University)' THEN 45876260
            WHEN edc = '<=Primary' THEN 45878725
            WHEN edc = 'Secondary' THEN 45876261
	        ELSE 0
        END AS individual_concept_id,
	       5 AS pos
	FROM "secondary-data".ppd_data
	WHERE edc IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       CASE
            WHEN ocp1 = 'Participant has a wage/salaried work' THEN 45877708
            WHEN ocp1 = 'Participant has self-employed business work' THEN 3000000190
            WHEN ocp1 = 'Participant is a housewife by choice' THEN 3000000187
	        WHEN ocp1 = 'Participant is unable to find employment' THEN 45877709
	        ELSE 0
        END AS individual_concept_id,
	       6 AS pos
	FROM "secondary-data".ppd_data
	WHERE ocp1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       CASE
            WHEN mod = 'Vaginal delivery' THEN 44784097
            WHEN mod = 'Caesarean Section' THEN 4015701
	        ELSE 0
        END AS individual_concept_id,
	       7 AS pos
	FROM "secondary-data".ppd_data
	WHERE mod IS NOT NULL
	
	ORDER BY ssid ASC, pos ASC
)

INSERT INTO mh_staging_1_1.individual_demographics(
	individual_demographics_id,
    individual_id,
    individual_concept_id,
    individual_concept_id_text
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_individual_demographics_id AS individual_demographics_id,
mh_staging_1_1.individual.individual_id AS individual_id,
individual_demographics_ppd.individual_concept_id AS individual_concept_id,
mh_staging_1_1.concept.concept_text AS individual_concept_id_text
FROM max_id, individual_demographics_ppd
INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = individual_demographics_ppd.ssid
LEFT JOIN mh_staging_1_1.concept
	ON mh_staging_1_1.concept.concept_id = individual_demographics_ppd.individual_concept_id;
	
--- Error solving

DELETE FROM mh_staging_1_1.individual_demographics
WHERE individual_demographics_id > 45335;

---Checking accuracy of entry

SELECT * FROM mh_staging_1_1.individual_demographics
WHERE individual_demographics_id > 45335


SELECT individual_id,
  COUNT (individual_id) AS count
FROM mh_staging_1_1.individual_demographics
WHERE individual_demographics_id > 45335
GROUP BY individual_id
ORDER BY count DESC

