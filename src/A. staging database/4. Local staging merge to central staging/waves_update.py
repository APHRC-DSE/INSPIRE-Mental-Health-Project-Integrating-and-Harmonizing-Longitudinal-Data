from library import *
from schema.schema import staging_tables

schemas = {"local":"study_12_wave_2_staging", "central":"mh_staging_1_1_dev"}
study_id = 12
wave_delta_schema = "study_12_wave_2_delta"

query_individual = """
SELECT * INTO {3}.individual FROM 
(
SELECT * FROM {1}.individual

EXCEPT ALL

(SELECT DISTINCT
A.*
FROM {0}.individual AS A LEFT JOIN (SELECT DISTINCT individual_id, population_study_id FROM {0}.longitudinal_population_study_fact) AS B
ON B.individual_id = A.individual_id
WHERE B.population_study_id = {2} ORDER BY A.individual_id)
) AS individual_delta;


""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_individual)


query_household = """
SELECT * INTO {3}.household FROM 
(
SELECT * FROM {1}.household 

EXCEPT ALL

(SELECT DISTINCT A.* FROM {0}.household AS A 
INNER JOIN (SELECT DISTINCT individual_id, household_id FROM {0}.individual) AS B ON B.household_id = A.household_id
INNER JOIN (SELECT DISTINCT individual_id, population_study_id FROM {0}.longitudinal_population_study_fact) AS C ON C.individual_id = B.individual_id
WHERE C.population_study_id = {2} ORDER BY A.household_id)
) AS household_delta;


""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_household)


query_location = """
SELECT * INTO {3}.location FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.location 
),

t2 AS (
SELECT DISTINCT A.* FROM {0}.location as A 
LEFT JOIN (SELECT DISTINCT household_id,location_id FROM {0}.household) AS B ON B.location_id = A.location_id
LEFT JOIN (SELECT DISTINCT individual_id, household_id FROM {0}.individual) AS C ON C.household_id = B.household_id
LEFT JOIN (SELECT DISTINCT individual_id, population_study_id FROM {0}.longitudinal_population_study_fact) AS D ON D.individual_id = C.individual_id
WHERE D.population_study_id = {2} ORDER BY A.location_id
)

SELECT t1.* 
FROM t1
LEFT JOIN t2 
ON t1.location_id = t2.location_id
WHERE t2.location_id IS NULL
ORDER BY t1.location_id
) AS location_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_location)


query_individual_demographics = """
SELECT * INTO {3}.individual_demographics FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.individual_demographics
),
t2 AS (
    SELECT A.*
    FROM {0}.individual_demographics AS A
    LEFT JOIN (
        SELECT DISTINCT individual_id, population_study_id
        FROM {0}.longitudinal_population_study_fact
    ) AS B ON B.individual_id = A.individual_id
    WHERE B.population_study_id = {2}  
)
SELECT t1.*
FROM t1
LEFT JOIN t2
ON t1.individual_concept_id = t2.individual_concept_id
AND t1.individual_id = t2.individual_id
WHERE t2.individual_id IS NULL  -- Filter out matches
ORDER BY t1.individual_demographics_id, t1.individual_id
) AS individual_demographics_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_individual_demographics)



query_household_characteristics = """
SELECT * INTO {3}.household_characteristics FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.household_characteristics
),
t2 AS (
    SELECT A.*
    FROM {0}.household_characteristics AS A
	LEFT JOIN (SELECT individual_id, household_id FROM {0}.individual) AS B ON B.household_id = A.household_id
    LEFT JOIN (
        SELECT DISTINCT individual_id, population_study_id
        FROM {0}.longitudinal_population_study_fact
    ) AS C
	ON C.individual_id = B.individual_id
    WHERE C.population_study_id = {2} ORDER BY A.household_characteristics_id, A.household_id
)
SELECT t1.*
FROM t1
LEFT JOIN 
t2
ON t1.household_characteristics_concept_id = t2.household_characteristics_concept_id
AND t1.household_id = t2.household_id
WHERE t2.household_id IS NULL -- Filter out matches
ORDER BY t1.household_characteristics_id, t1.household_id
) AS household_characteristics_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_household_characteristics)

query_interviews = """
SELECT * INTO {3}.interview FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.interview
),
t2 AS (
    SELECT A.*
    FROM {0}.interview AS A
    LEFT JOIN (
        SELECT DISTINCT individual_id, population_study_id
        FROM {0}.longitudinal_population_study_fact
    ) AS B
	ON B.individual_id = A.individual_id
    WHERE B.population_study_id = {2}  ORDER BY A.interview_id, A.individual_id
)
SELECT t1.*
FROM t1
LEFT JOIN 
t2
ON t1.individual_id = t2.individual_id
AND t1.instrument_id = t2.instrument_id
WHERE t2.individual_id IS NULL OR t1.interview_date != t2.interview_date -- Filter out matches
ORDER BY t1.interview_id, t1.individual_id
) AS interview_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)


print(query_interviews)

query_residence_episode = """
SELECT * INTO {3}.resident_episode FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.resident_episode
),
t2 AS (
    SELECT DISTINCT A.*
    FROM {0}.resident_episode AS A
	LEFT JOIN (SELECT individual_id, household_id FROM {0}.individual) AS B ON B.household_id = A.household_id
    LEFT JOIN (
        SELECT DISTINCT individual_id, population_study_id
        FROM {0}.longitudinal_population_study_fact
    ) AS C ON C.individual_id = B.individual_id
    WHERE C.population_study_id = {2}
)
SELECT t1.*
FROM t1
LEFT JOIN t2
ON t1.household_id = t2.household_id
AND t1.location_id = t2.location_id
WHERE t1.wave_id >1  -- UPDATE ACCORDING TO THE HIGHEST WAVE NUMBER MERGED , This will pick wave 2 episodes
ORDER BY t1.resident_episode_id, t1.household_id
) AS resident_episode_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_residence_episode)

query_population_fact = """

SELECT * INTO {3}.longitudinal_population_study_fact FROM 
(
WITH t1 AS (
    SELECT * FROM {1}.longitudinal_population_study_fact 
),
t2 AS (
    SELECT A.*
    FROM {0}.longitudinal_population_study_fact AS A 
	WHERE A.population_study_id={2} ORDER BY fact_id 

)
SELECT t1.*
FROM t1
LEFT JOIN t2
ON t1.individual_id = t2.individual_id
WHERE t1.fact_id IS NULL -- Filter out matches
ORDER BY t1.fact_id, t1.individual_id
) AS fact_table_delta;
""".format(schemas["central"], schemas["local"], study_id,wave_delta_schema)

print(query_population_fact)