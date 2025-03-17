# A. staging database
This folder contains information and code on the structure of the staging database, generated metadata tables from the various studies, ETL(extract, transform and load) source data to a local instance of the staging database, merging various local instances to central staging data base and visualizing the database on a platform.

The steps follow a chronological order as below:

## 1. Creating the Staging database

The staging database follows the **DDI Lifecycle specification**, chronicling the execution of longitudinal studies from one wave to the next across a dynamic population with in-migration and out-migration, as the case may be. Also, from one wave to the next there may be one or more mental health instruments.

![image](../../images/LS%20Fact%20v4-3.png)

This staging database is structured as a **star schema** and has three `endpoints`: 

    1. It is a window into study execution and is the basis for reporting
    2. Studies in the staging database may be ETLed into the OMOP CDM for 
    subsequent descriptive, predictive and causal analysis
    3. It can be used to produce an OMOP standard vocabulary like UK Biobank in [Athena](https://athena.ohdsi.org/search-terms/start)

The staging database structure was designed using a Relational Database Diagram Design Tool [dbdiagram](https://dbdiagram.io/). The Design for the staging can be found [here](https://dbdiagram.io/d/MH-INSPIRE-Staging-Dataset-v1-1-65fa7820ae072629ce783398).

Design documentation, ERD (Entity-Relationship Diagram) and schema ddl for the staging can be found in the [1. staging db](./1.%20staging%20db) folder.
    
## 2. Generating Metadata tables
The **staging database contains 15 tables**: `Concept`, `Data capture Event`, `Household`, `Household Characteristics`,
`Individual`, `Individual Demographics`, `Instrument`, `Instrument Item`, `Interview`, `Location`,
`Longitudinal Population Study Fact`, `Methodology`, `Population Study`, `Resident Episode`, and `Wave`.

Of the 15 tables, **7 are metadata tables** i.e. `Concept`, `Data capture Event`, `Instrument`, `Instrument Item`, `Methodology`, `Population Study` and `Wave`.

Metadata generated is from 14 population longitudinal studies (11 secondary and 3 primary). See Table in _3. ETL from source data to staging_

Any Metadata for subsequent data received from primary collection sites will be added to the tables.

Metadata for the 14 population longitudinal studies can be found in the [2. metadata](./2.%20metadata) folder.

## 3. ETL from source data to staging

### Data processing
Data processing is a crucial aspect of any data related project and involves organizing, cleaning, and preparing data for analysis using appropriate tools and techniques.

In this project, data processing was done using various tools i.e `R`, `Pentaho` and `Python` to clean and subset variables.

### Vocabulary Mapping
Sometimes the source data uses coding systems that are not in the Vocabulary. In this case, a mapping must be created from the source coding system to the Standard Concepts. Code mapping can be a daunting task, especially when there are many codes in the source coding system. 

In this project, `Usagi` and `Athena` were used to map vocabularies of source concepts.

#### Usagi
[Usagi](https://ohdsi.github.io/Usagi/index.html) is a tool to aid the manual process of creating a code mapping. It can make suggested mappings based on textual similarity of code descriptions. If the source codes are only available in a foreign language, **Google Translate** often gives good translation of the terms into English. Usagi allows the user to search for the appropriate target concepts if the automated suggestion is not correct. Finally, the user can indicate which mappings are approved to be used in the ETL.

The typical sequence for using this software is:

- Load codes from your sources system (“source codes”) that you would like to map to Vocabulary concepts.
- Usagi will run a term similarity approach to map source codes to Vocabulary concepts.
- Leverage Usagi interface to check, and where needed, improve suggested mappings. Preferably an individual who has experience with the coding system and medical terminology should be used for this review.
- Export mapping to the Vocabulary’s _SOURCE_TO_CONCEPT_MAP_.

### Implementation of the ETL 
It is important to clearly separate the design of the ETL from the implementation of the ETL. Designing the ETL requires extensive knowledge of both the source data. Implementing the ETL on the other hand typically relies mostly on technical expertise on how to make the ETL computationally efficient.

In this project, implementation of the ETL to the staging database was done using various tools i.e `PostgreSQL`, `Pentaho` and `Python`.

| **study** | **data source** | **study country** | **source title** | **link doi** | **tools used** | **Data processing tool** | **ETL tool to Staging** |
|---|---|---|---|---|---|---|---|
| **1** | Secondary | Kenya | Demographic, Psychosocial And Clinical Factors Associated With Postpartum Depression In Kenyan Women | https://doi.org/10.1186/s12888-018-1904-7 | Edinburgh Postnatal Depression Scale (EPDS) | R | PostgreSQL |
| **2** | Secondary | Ethiopia | Longitudinal Mediation Analysis Of The Factors Associated With Trajectories Of Posttraumatic Stress Disorder Symptoms Among Postpartum Women In Northwest Ethiopia: Application Of The Karlson-Holm-Breen (Khb) Method | https://doi.org/10.1371/journal.pone.0266399 | Depression Anxiety Stress Scale (DASS-21);Traumatic Event Scale (TES);Posttraumatic Stress Disorder Checklist for DSM-5 (PCL-5);WHOQOL-BREF;WHO Disability Assessment Schedule (WHODAS 2.0);Wijma Delivery Expectation/Experience Questionnaire (W-DEQ);List of Threatening Experiences Questionnaire (LTE-Q);Oslo Social Support Scale (OSSS-3);WHO (2005) multi country study questionnaire on domestic violence | R | PostgreSQL |
| **3** | Secondary | Ethiopia | Longitudinal Path Analysis For The Directional Association Of Depression, Anxiety And Posttraumatic Stress Disorder With Their Comorbidities And Associated Factors Among Postpartum Women In Northwest Ethiopia: A Cross-Lagged Autoregressive Modelling Study | https://doi.org/10.1371/journal.pone.0273176 | Depression Anxiety Stress Scale (DASS-21);Traumatic Event Scale (TES);Posttraumatic Stress Disorder Checklist for DSM-5 (PCL-5);Wijma Delivery Expectation/Experience Questionnaire (W-DEQ);Oslo Social Support Scale (OSSS-3) | R | PostgreSQL |
| **4** | Secondary | South Africa | Lifestyle Factors, Mental Health, And Incident And Persistent Intrusive Pain Among Ageing Adults In South Africa | https://doi.org/10.1515/sjpain-2022-0013 | Brief Pain Inventory (BPI);General Physical Activity Questionnaire (GPAQ);Center for Epidemiological Studies-Depression (CES-D);Posttraumatic Stress Disorder (PTSD) scale by Breslau;Brief Version of the Pittsburgh Sleep Quality Index (B-PSQI) | Pentaho | Pentaho |
| **5** | Secondary | South Africa | Self-Reported Sleep Duration And Its Correlates With Sociodemographics, Health Behaviours, Poor Mental Health, And Chronic Conditions In Rural Persons 40 Years And Older In South Africa | https://doi.org/10.3390/ijerph15071357 | Cut down-Annoyed-Guilty-Eye opener (CAGE);General Physical Activity Questionnaire (GPAQ);Center for Epidemiological Studies-Depression (CES-D);Posttraumatic Stress Disorder (PTSD) scale by Breslau | Pentaho | Pentaho |
| **6** | Secondary | South Africa | The Relationship Between Negative Household Events And Depressive Symptoms: Evidence From South African Longitudinal Data | https://doi.org/10.1016/j.jad.2017.04.031 | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **7** | Secondary | South Africa | Simultaneous Social Causation And Social Drift: Longitudinal Analysis Of Depression And Poverty In South Africa | https://doi.org/10.1016/j.jad.2017.12.050 | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **8** | Secondary | South Africa | A Nationwide Panel Study On Religious Involvement And Depression In South Africa: Evidence From The South African National Income Dynamics Study | https://doi.org/10.1007/s10943-017-0551-5 | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **9** | Secondary | South Africa | Evidence On The Association Between Cigarette Smoking And Incident Depression From The South African National Income Dynamics Study 2008-2015: Mental Health Implications For A Resource-Limited Setting | https://doi.org/10.1093/ntr/nty163 | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **10** | Secondary | South Africa | Proximity To Healthcare Clinic And Depression Risk In South Africa: Geospatial Evidence From A Nationally Representative Longitudinal Study | https://doi.org/10.1007/s00127-017-1369-x | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **11** | Secondary | South Africa | Living Alone And Depression In A Developing Country Context: Longitudinal Evidence From South Africa | https://doi.org/10.1016/j.ssmph.2021.100800 | Center for Epidemiological Studies-Depression (CES-D) | R | PostgreSQL |
| **12** | Primary | Uganda | Iganga Mayuge HDSS | https://doi.org/10.1093/ije/dyaa064 | Patient Health Questionnaire (PHQ-9); Generalized Anxiety Disorder (GAD-7); Psychosis Screening Questionnaire (PSQ) | Pentaho | Pentaho |
| **13** | Primary | Uganda | Kagando HDSS |  | Patient Health Questionnaire (PHQ-9); Generalized Anxiety Disorder (GAD-7); Psychosis Screening Questionnaire (PSQ) | Python | Python |
| **14** | Primary | Kenya | Kilifi HDSS |  | Patient Health Questionnaire (PHQ-9); Generalized Anxiety Disorder (GAD-7); Psychosis Screening Questionnaire (PSQ) | Pentaho | Pentaho |

ETL implementation for the 14 population longitudinal studies can be found in the [3. ETL-source to staging](./3.%20ETL-source%20to%20staging) folder.

## 4. Merge the various ETL-source data to staging instances to central staging database


## 5. Create Visualization platform (Metabase)






