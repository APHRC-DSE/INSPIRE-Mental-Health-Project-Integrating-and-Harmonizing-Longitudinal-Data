SET search_path TO mh_staging;

show search_path;

--- Concept table
COPY mh_staging_1_1.concept 
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\concept_table_study_1.csv'  
WITH DELIMITER ',' CSV HEADER;

--- Location table
COPY (SELECT * FROM mh_staging_1_1.location WHERE location_id > 7567) 
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\location_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Household table
COPY (SELECT * FROM mh_staging_1_1.household WHERE household_id > 7567)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\household_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Household characteristics table
COPY (SELECT * FROM mh_staging_1_1.household_characteristics WHERE household_characteristics_id > 22860)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\household_characteristics_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Individual table
COPY (SELECT * FROM mh_staging_1_1.individual WHERE individual_id > 9067)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\individual_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Individual demographics table
COPY (SELECT * FROM mh_staging_1_1.individual_demographics WHERE individual_demographics_id > 45335)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\individual_demographics_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Interview table
COPY (SELECT * FROM mh_staging_1_1.interview WHERE interview_id > 27201)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\interview_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Resident episode table
COPY (SELECT * FROM mh_staging_1_1.resident_episode WHERE resident_episode_id > 7567)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\resident_episode_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;

--- Longitudinal population study fact table
COPY (SELECT * FROM mh_staging_1_1.longitudinal_population_study_fact WHERE fact_id > 380814)
TO 'D:\APHRC\OMOP-CDM\OMOP_ETL Work\PPD_to_OMOP_ETL\7.CSV dumps\lps_fact_table_study_1.csv'
WITH DELIMITER ',' CSV HEADER;






