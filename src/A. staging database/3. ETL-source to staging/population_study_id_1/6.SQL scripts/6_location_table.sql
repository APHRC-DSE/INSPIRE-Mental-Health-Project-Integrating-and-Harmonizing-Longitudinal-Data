SET search_path TO mh_staging;

show search_path;

-- CTE 
---max row number 7567 
WITH max_id AS(
	SELECT max(location_id) AS max_location_id
			   FROM mh_staging_1_1.location
)
-- SELECT * FROM max_id

INSERT INTO mh_staging_1_1.location(
	location_id,
    village_name,
    place_kind,
    latitude,
    longitude
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_location_id AS location_id,
'Nairobi County' AS village_name,
'Urban' AS place_kind ,
-1.3021282 AS latitude,
36.7203683 AS longitude
FROM (SELECT ssid FROM "secondary-data".ppd_data
	 LIMIT 1
	 ) AS derivedtable, max_id ;
	
--- Error solving

DELETE FROM mh_staging_1_1.location 
WHERE location_id > 7567;

---Checking accuracy of entry

SELECT * FROM mh_staging_1_1.location
WHERE location_id > 7567