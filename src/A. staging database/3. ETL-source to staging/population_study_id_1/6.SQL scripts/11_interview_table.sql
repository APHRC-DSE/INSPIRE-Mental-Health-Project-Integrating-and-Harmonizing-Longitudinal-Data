SET search_path TO mh_staging;

show search_path;

--CTE 
---max row interview number 27201 
WITH max_id AS(
	SELECT max(interview_id) AS max_interview_id
			   FROM mh_staging_1_1.interview
),
interview_ppd (ssid, interview_date, wave_id, instrument_id) AS(
	SELECT ssid,
	       dtsd AS interview_date,
	       1 AS wave_id,
	       4 AS instrument_id
			   FROM "secondary-data".ppd_data
	
	UNION ALL
	
	SELECT ssid,
	       dtpnrf AS interview_date,
	       2 AS wave_id,
	       4 AS instrument_id
			   FROM "secondary-data".ppd_data
	WHERE id2 IS NOT NULL
	
	ORDER BY ssid ASC, wave_id ASC, instrument_id ASC 
)

INSERT INTO mh_staging_1_1.interview(
interview_id,
individual_id,
interview_date,
wave_id,
instrument_id
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_interview_id AS interview_id,
mh_staging_1_1.individual.individual_id AS individual_id,
interview_ppd.interview_date::DATE AS interview_date,
interview_ppd.wave_id AS wave_id,
interview_ppd.instrument_id AS instrument_id
FROM max_id, interview_ppd
INNER JOIN mh_staging_1_1.individual
    ON mh_staging_1_1.individual.individual_id_value = interview_ppd.ssid;
	
--- Error solving

DELETE FROM mh_staging_1_1.interview
WHERE interview_id > 27201;

---Checking accuracy of entry

SELECT * FROM mh_staging_1_1.interview
WHERE interview_id > 27201