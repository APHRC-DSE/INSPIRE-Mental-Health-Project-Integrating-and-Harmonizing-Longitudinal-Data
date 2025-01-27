SET search_path TO mh_staging;

show search_path;

--CTE 
---max row household id 7567
WITH max_id AS(
	SELECT max(household_id) AS max_household_id
			   FROM mh_staging_1_1.household
),
household_ppd (ssid, location_name) AS(
	SELECT ssid AS ssid,
	'Nairobi County' AS location_name
			   FROM "secondary-data".ppd_data
	ORDER BY ssid
)

INSERT INTO mh_staging_1_1.household(
	household_id,
	household_id_value,
    location_id,
    household_head_id
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_household_id AS household_id,
ssid AS household_id_value,
mh_staging_1_1.location.location_id AS location_id,
0 AS household_head_id
FROM max_id, household_ppd
INNER JOIN mh_staging_1_1.location
ON mh_staging_1_1.location.village_name = household_ppd.location_name;
	
--- Error solving
DELETE FROM mh_staging_1_1.household
WHERE household_id > 7567;

---Checking accuracy of entry
SELECT * FROM mh_staging_1_1.household
WHERE household_id > 7567;

