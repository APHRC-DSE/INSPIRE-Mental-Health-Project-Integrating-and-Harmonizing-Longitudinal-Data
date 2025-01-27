SET search_path TO mh_staging;

show search_path;

--CTE 
---max row resident episode id 7567
WITH max_id AS(
	SELECT max(resident_episode_id) AS max_resident_episode_id
			   FROM mh_staging_1_1.resident_episode
),
resident_ppd (household_id, household_id_value, location_id, wave_id, ssid) AS(
	SELECT mh_staging_1_1.household.household_id AS household_id,
	       mh_staging_1_1.household.household_id_value AS household_id_value,
	       mh_staging_1_1.household.location_id AS location_id,
	       1 AS wave_id,
	       "secondary-data".ppd_data.ssid AS ssid
	FROM mh_staging_1_1.household
	INNER JOIN "secondary-data".ppd_data
	ON "secondary-data".ppd_data.ssid = mh_staging_1_1.household.household_id_value
	
	UNION ALL
	
	SELECT mh_staging_1_1.household.household_id AS household_id,
	       mh_staging_1_1.household.household_id_value AS household_id_value,
	       mh_staging_1_1.household.location_id AS location_id,
	       2 AS wave_id,
	       "secondary-data".ppd_data.ssid AS ssid
	FROM mh_staging_1_1.household
	INNER JOIN "secondary-data".ppd_data
	ON "secondary-data".ppd_data.ssid = mh_staging_1_1.household.household_id_value
	WHERE "secondary-data".ppd_data.id2 IS NOT NULL
	
	ORDER BY ssid ASC, wave_id ASC
)

INSERT INTO mh_staging_1_1.resident_episode(
	resident_episode_id,
	location_id,
	household_id,
    wave_id
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_resident_episode_id AS resident_episode_id,
resident_ppd.location_id AS location_id,
resident_ppd.household_id AS household_id,
resident_ppd.wave_id AS wave_id
FROM max_id, resident_ppd;
	
--- Error solving
DELETE FROM mh_staging_1_1.resident_episode
WHERE resident_episode_id > 7567;

---Checking accuracy of entry
SELECT * FROM mh_staging_1_1.resident_episode
WHERE resident_episode_id > 7567;

