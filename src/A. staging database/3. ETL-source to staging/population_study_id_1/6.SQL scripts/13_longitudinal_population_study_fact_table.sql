SET search_path TO mh_staging;

show search_path;

--CTE 
---max row fact number 380814
WITH max_id AS(
	SELECT 
	max(fact_id) AS max_fact_id
			   FROM mh_staging_1_1.longitudinal_population_study_fact
),
lps_fact_ppd (ssid, individual_id, household_id, wave_id, population_study_id, instrument_id, instrument_item_id, concept_id, value_type_concept_id, value_as_num) AS(
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       22 AS instrument_item_id,
	       CASE
            WHEN lgh1 = 'As much as I always could' THEN 45878094
            WHEN lgh1 = 'Not quite so much now' THEN 45877849
            WHEN lgh1 = 'Definitely not so much now' THEN 45878095
            WHEN lgh1 = 'Not at all' THEN 45883172
	        ELSE 0
        END AS concept_id,
	       42870286 AS value_type_concept_id,
	       CASE
            WHEN lgh1 = 'As much as I always could' THEN 0
            WHEN lgh1 = 'Not quite so much now' THEN 1
            WHEN lgh1 = 'Definitely not so much now' THEN 2
            WHEN lgh1 = 'Not at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE lgh1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       22 AS instrument_item_id,
	       CASE
            WHEN lgh2 = 'As much as I always could' THEN 45878094
            WHEN lgh2 = 'Not quite so much now' THEN 45877849
            WHEN lgh2 = 'Definitely not so much now' THEN 45878095
            WHEN lgh2 = 'Not at all' THEN 45883172
	        ELSE 0
        END AS concept_id,
	       42870286 AS value_type_concept_id,
	       CASE
            WHEN lgh2 = 'As much as I always could' THEN 0
            WHEN lgh2 = 'Not quite so much now' THEN 1
            WHEN lgh2 = 'Definitely not so much now' THEN 2
            WHEN lgh2 = 'Not at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE lgh2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       23 AS instrument_item_id,
	       CASE
            WHEN enjy1 = 'As much as I ever did' THEN 45885323
            WHEN enjy1 = 'Rather less than I used to' THEN 45879387
            WHEN enjy1 = 'Definitely less than I used to' THEN 45880856
            WHEN enjy1 = 'Hardly at all' THEN 45879388
	        ELSE 0
        END AS concept_id,
	       42870287 AS value_type_concept_id,
	       CASE
            WHEN enjy1 = 'As much as I ever did' THEN 0
            WHEN enjy1 = 'Rather less than I used to' THEN 1
            WHEN enjy1 = 'Definitely less than I used to' THEN 2
            WHEN enjy1 = 'Hardly at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE enjy1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       23 AS instrument_item_id,
	       CASE
            WHEN enjy2 = 'As much as I ever did' THEN 45885323
            WHEN enjy2 = 'Rather less than I used to' THEN 45879387
            WHEN enjy2 = 'Definitely less than I used to' THEN 45880856
            WHEN enjy2 = 'Hardly at all' THEN 45879388
	        ELSE 0
        END AS concept_id,
	       42870287 AS value_type_concept_id,
	       CASE
            WHEN enjy2 = 'As much as I ever did' THEN 0
            WHEN enjy2 = 'Rather less than I used to' THEN 1
            WHEN enjy2 = 'Definitely less than I used to' THEN 2
            WHEN enjy2 = 'Hardly at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE enjy2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       24 AS instrument_item_id,
	       CASE
            WHEN blmd1 = 'No-never' THEN 45880857
            WHEN blmd1 = 'Yes-some of the time' THEN 45880858
            WHEN blmd1 = 'Not very often' THEN 45880859
            WHEN blmd1 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870288 AS value_type_concept_id,
	       CASE
            WHEN blmd1 = 'No-never' THEN 0
            WHEN blmd1 = 'Yes-some of the time' THEN 2
            WHEN blmd1 = 'Not very often' THEN 1
            WHEN blmd1 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE blmd1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       24 AS instrument_item_id,
	       CASE
            WHEN blmd2 = 'No-never' THEN 45880857
            WHEN blmd2 = 'Yes-some of the time' THEN 45880858
            WHEN blmd2 = 'Not very often' THEN 45880859
            WHEN blmd2 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870288 AS value_type_concept_id,
	       CASE
            WHEN blmd2 = 'No-never' THEN 0
            WHEN blmd2 = 'Yes-some of the time' THEN 2
            WHEN blmd2 = 'Not very often' THEN 1
            WHEN blmd2 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE blmd2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       25 AS instrument_item_id,
	       CASE
            WHEN anxs1 = 'No-not at all' THEN 45885119
            WHEN anxs1 = 'Yes-sometimes' THEN 45879997
            WHEN anxs1 = 'Hardly ever' THEN 45884598
            WHEN anxs1 = 'Yes-very often' THEN 45877850
	        ELSE 0
        END AS concept_id,
	       42870289 AS value_type_concept_id,
	       CASE
            WHEN anxs1 = 'No-not at all' THEN 0
            WHEN anxs1 = 'Yes-sometimes' THEN 2
            WHEN anxs1 = 'Hardly ever' THEN 1
            WHEN anxs1 = 'Yes-very often' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE anxs1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       25 AS instrument_item_id,
	       CASE
            WHEN anxs2 = 'No-not at all' THEN 45885119
            WHEN anxs2 = 'Yes-sometimes' THEN 45879997
            WHEN anxs2 = 'Hardly ever' THEN 45884598
            WHEN anxs2 = 'Yes-very often' THEN 45877850
	        ELSE 0
        END AS concept_id,
	       42870289 AS value_type_concept_id,
	       CASE
            WHEN anxs2 = 'No-not at all' THEN 0
            WHEN anxs2 = 'Yes-sometimes' THEN 2
            WHEN anxs2 = 'Hardly ever' THEN 1
            WHEN anxs2 = 'Yes-very often' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE anxs2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       26 AS instrument_item_id,
	       CASE
            WHEN scrd1 = 'No-not at all' THEN 45885119
            WHEN scrd1 = 'No-not much' THEN 45879389
            WHEN scrd1 = 'Yes-sometimes' THEN 45879997
            WHEN scrd1 = 'Yes-quite a lot' THEN 45885324
	        ELSE 0
        END AS concept_id,
	       42870290 AS value_type_concept_id,
	       CASE
            WHEN scrd1 = 'No-not at all' THEN 0
            WHEN scrd1 = 'No-not much' THEN 1
            WHEN scrd1 = 'Yes-sometimes' THEN 2
            WHEN scrd1 = 'Yes-quite a lot' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE scrd1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       26 AS instrument_item_id,
	       CASE
            WHEN scrd2 = 'No-not at all' THEN 45885119
            WHEN scrd2 = 'No-not much' THEN 45879389
            WHEN scrd2 = 'Yes-sometimes' THEN 45879997
            WHEN scrd2 = 'Yes-quite a lot' THEN 45885324
	        ELSE 0
        END AS concept_id,
	       42870290 AS value_type_concept_id,
	       CASE
            WHEN scrd2 = 'No-not at all' THEN 0
            WHEN scrd2 = 'No-not much' THEN 1
            WHEN scrd2 = 'Yes-sometimes' THEN 2
            WHEN scrd2 = 'Yes-quite a lot' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE scrd2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       29 AS instrument_item_id,
	       CASE
            WHEN sad1 = 'No-not at all' THEN 45885119
            WHEN sad1 = 'Not very often' THEN 45880859
            WHEN sad1 = 'Yes-quite often' THEN 45879391
            WHEN sad1 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870293 AS value_type_concept_id,
	       CASE
            WHEN sad1 = 'No-not at all' THEN 0
            WHEN sad1 = 'Not very often' THEN 1
            WHEN sad1 = 'Yes-quite often' THEN 2
            WHEN sad1 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE sad1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       29 AS instrument_item_id,
	       CASE
            WHEN sad2 = 'No-not at all' THEN 45885119
            WHEN sad2 = 'Not very often' THEN 45880859
            WHEN sad2 = 'Yes-quite often' THEN 45879391
            WHEN sad2 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870293 AS value_type_concept_id,
	       CASE
            WHEN sad2 = 'No-not at all' THEN 0
            WHEN sad2 = 'Not very often' THEN 1
            WHEN sad2 = 'Yes-quite often' THEN 2
            WHEN sad2 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE sad2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       27 AS instrument_item_id,
	       CASE
            WHEN thng1 = 'No-most of the time I have coped quite well' THEN 45877851
            WHEN thng1 = 'No-I have been coping as well as ever' THEN 45885325
            WHEN thng1 = 'Yes-sometimes I have not been coping as well as usual' THEN 45881507
            WHEN thng1 = 'Yes-most of the time I have not been able to cope at all' THEN 45879390
	        ELSE 0
        END AS concept_id,
	       42870291 AS value_type_concept_id,
	       CASE
            WHEN thng1 = 'No-most of the time I have coped quite well' THEN 1
            WHEN thng1 = 'No-I have been coping as well as ever' THEN 0
            WHEN thng1 = 'Yes-sometimes I have not been coping as well as usual' THEN 2
            WHEN thng1 = 'Yes-most of the time I have not been able to cope at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE thng1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       27 AS instrument_item_id,
	       CASE
            WHEN thng2 = 'No-most of the time I have coped quite well' THEN 45877851
            WHEN thng2 = 'No-I have been coping as well as ever' THEN 45885325
            WHEN thng2 = 'Yes-sometimes I have not been coping as well as usual' THEN 45881507
            WHEN thng2 = 'Yes-most of the time I have not been able to cope at all' THEN 45879390
	        ELSE 0
        END AS concept_id,
	       42870291 AS value_type_concept_id,
	       CASE
            WHEN thng2 = 'No-most of the time I have coped quite well' THEN 1
            WHEN thng2 = 'No-I have been coping as well as ever' THEN 0
            WHEN thng2 = 'Yes-sometimes I have not been coping as well as usual' THEN 2
            WHEN thng2 = 'Yes-most of the time I have not been able to cope at all' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE thng2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       30 AS instrument_item_id,
	       CASE
            WHEN cryn1 = 'No-never' THEN 45880857
            WHEN cryn1 = 'Only occasionally' THEN 45885326
            WHEN cryn1 = 'Yes-most of the time' THEN 45881507
            WHEN cryn1 = 'Yes-quite often' THEN 45879390
	        ELSE 0
        END AS concept_id,
	       42870294 AS value_type_concept_id,
	       CASE
            WHEN cryn1 = 'No-never' THEN 0
            WHEN cryn1 = 'Only occasionally' THEN 1
            WHEN cryn1 = 'Yes-most of the time' THEN 3
            WHEN cryn1 = 'Yes-quite often' THEN 2
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE cryn1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       30 AS instrument_item_id,
	       CASE
            WHEN cryn2 = 'No-never' THEN 45880857
            WHEN cryn2 = 'Only occasionally' THEN 45885326
            WHEN cryn2 = 'Yes-most of the time' THEN 45881507
            WHEN cryn2 = 'Yes-quite often' THEN 45879390
	        ELSE 0
        END AS concept_id,
	       42870294 AS value_type_concept_id,
	       CASE
            WHEN cryn2 = 'No-never' THEN 0
            WHEN cryn2 = 'Only occasionally' THEN 1
            WHEN cryn2 = 'Yes-most of the time' THEN 3
            WHEN cryn2 = 'Yes-quite often' THEN 2
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE cryn2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       28 AS instrument_item_id,
	       CASE
            WHEN slpn1 = 'No-not at all' THEN 45885119
            WHEN slpn1 = 'No-Not very often' THEN 45880859
            WHEN slpn1 = 'Yes-sometimes' THEN 45879997
            WHEN slpn1 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870292 AS value_type_concept_id,
	       CASE
            WHEN slpn1 = 'No-not at all' THEN 0
            WHEN slpn1 = 'No-Not very often' THEN 1
            WHEN slpn1 = 'Yes-sometimes' THEN 2
            WHEN slpn1 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE slpn1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       28 AS instrument_item_id,
	       CASE
            WHEN slpn2 = 'No-not at all' THEN 45885119
            WHEN slpn2 = 'No-Not very often' THEN 45880859
            WHEN slpn2 = 'Yes-sometimes' THEN 45879997
            WHEN slpn2 = 'Yes-most of the time' THEN 45885120
	        ELSE 0
        END AS concept_id,
	       42870292 AS value_type_concept_id,
	       CASE
            WHEN slpn2 = 'No-not at all' THEN 0
            WHEN slpn2 = 'No-Not very often' THEN 1
            WHEN slpn2 = 'Yes-sometimes' THEN 2
            WHEN slpn2 = 'Yes-most of the time' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE slpn2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       31 AS instrument_item_id,
	       CASE
            WHEN hrmg1 = 'Never' THEN 45876662
            WHEN hrmg1 = 'Hardly ever' THEN 45884598
            WHEN hrmg1 = 'Sometimes' THEN 45882528
            WHEN hrmg1 = 'Yes-quite often' THEN 45879391
	        ELSE 0
        END AS concept_id,
	       42870295 AS value_type_concept_id,
	       CASE
            WHEN hrmg1 = 'Never' THEN 0
            WHEN hrmg1 = 'Hardly ever' THEN 1
            WHEN hrmg1 = 'Sometimes' THEN 2
            WHEN hrmg1 = 'Yes-quite often' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE hrmg1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       31 AS instrument_item_id,
	       CASE
            WHEN hrmg2 = 'Never' THEN 45876662
            WHEN hrmg2 = 'Hardly ever' THEN 45884598
            WHEN hrmg2 = 'Sometimes' THEN 45882528
            WHEN hrmg2 = 'Yes-quite often' THEN 45879391
	        ELSE 0
        END AS concept_id,
	       42870295 AS value_type_concept_id,
	       CASE
            WHEN hrmg2 = 'Never' THEN 0
            WHEN hrmg2 = 'Hardly ever' THEN 1
            WHEN hrmg2 = 'Sometimes' THEN 2
            WHEN hrmg2 = 'Yes-quite often' THEN 3
	        ELSE NULL
        END AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE hrmg2 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       1 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       32 AS instrument_item_id,
	       1989297 AS concept_id,
	       1989297 AS value_type_concept_id,
	       scr1 AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE scr1 IS NOT NULL
	
	UNION ALL
	
	SELECT ssid AS ssid,
	       mh_staging_1_1.individual.individual_id AS individual_id,
	       mh_staging_1_1.individual.household_id AS household_id,
	       2 AS wave_id,
	       1 AS population_study_id,
	       4 AS instrument_id,
	       32 AS instrument_item_id,
	       1989297 AS concept_id,
	       1989297 AS value_type_concept_id,
	       scr2 AS value_as_num
	FROM "secondary-data".ppd_data
	INNER JOIN mh_staging_1_1.individual
	ON mh_staging_1_1.individual.individual_id_value = "secondary-data".ppd_data.ssid
	WHERE scr2 IS NOT NULL
	
	ORDER BY ssid ASC, wave_id ASC, instrument_item_id ASC	
)

INSERT INTO mh_staging_1_1.longitudinal_population_study_fact(
	fact_id,
    individual_id,
	interview_id,
	resident_episode_id,
	population_study_id,
	instrument_id,
	instrument_item_id,
	concept_id,
	value_type_concept_id,
	value_as_char,
    value_as_num,
    value_as_concept,
    is_indv_level
)
SELECT 
ROW_NUMBER () OVER (ORDER BY ssid) + max_id.max_fact_id AS fact_id,
lps_fact_ppd.individual_id AS individual_id,
mh_staging_1_1.interview.interview_id AS interview_id,
mh_staging_1_1.resident_episode.resident_episode_id AS resident_episode_id,
lps_fact_ppd.population_study_id AS population_study_id,
lps_fact_ppd.instrument_id AS instrument_id,
lps_fact_ppd.instrument_item_id AS instrument_item_id,
lps_fact_ppd.concept_id AS concept_id,
lps_fact_ppd.value_type_concept_id AS value_type_concept_id,
concept1.concept_text AS value_as_char,
lps_fact_ppd.value_as_num AS value_as_num,
concept2.inspire_concept_id AS value_as_concept,
NULL AS is_indv_level
FROM max_id, lps_fact_ppd
LEFT JOIN mh_staging_1_1.concept AS concept1
	ON concept1.concept_id = lps_fact_ppd.concept_id
	AND CAST(concept1.score AS INT) = lps_fact_ppd.value_as_num
LEFT JOIN mh_staging_1_1.concept AS concept2
	ON concept2.concept_id = lps_fact_ppd.value_type_concept_id
LEFT JOIN mh_staging_1_1.interview
	ON mh_staging_1_1.interview.individual_id = lps_fact_ppd.individual_id
	AND mh_staging_1_1.interview.wave_id = lps_fact_ppd.wave_id
	AND mh_staging_1_1.interview.instrument_id = lps_fact_ppd.instrument_id
LEFT JOIN mh_staging_1_1.resident_episode
	ON mh_staging_1_1.resident_episode.household_id = lps_fact_ppd.household_id
	AND mh_staging_1_1.resident_episode.wave_id = lps_fact_ppd.wave_id

---Update data in table
UPDATE mh_staging_1_1.longitudinal_population_study_fact
SET value_type_concept_id = NULL
WHERE population_study_id = 1 AND instrument_item_id = 32;

---Error solving
DELETE FROM mh_staging_1_1.longitudinal_population_study_fact
WHERE fact_id > 380814;

---Checking accuracy of entry
SELECT * FROM mh_staging_1_1.longitudinal_population_study_fact
WHERE fact_id > 380814;

