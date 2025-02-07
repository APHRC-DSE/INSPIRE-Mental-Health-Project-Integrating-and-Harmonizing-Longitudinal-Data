# Staging database, metadata, ETL source to staging, and Metabase
This folder contains information and code on the structure of the staging database, generated metadata tables from the various studies, ETL(extract, transform and load) source data to a local instance of the staging database, merging various local instances to central staging data base and visualizing the database on a platform.

## Steps

### 1. Creating the Staging database

The staging database follows the **DDI Lifecycle specification**, chronicling the execution of longitudinal studies from one wave to the next across a dynamic population with in-migration and out-migration, as the case may be. Also, from one wave to the next there may be one or more mental health instruments.

This staging database is structured as a **star schema** has two `endpoints`: 

    1. It is a window into study execution and is the basis for reporting
    2. Studies in the staging database may be ETLed into the OMOP CDM for subsequent descriptive, predictive and causal 
    analysis

![Image](.../images/staging_db_data_pipeline.png)
    
### 2. Generating Metadata tables

