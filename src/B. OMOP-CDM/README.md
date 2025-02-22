# B. OMOP-CDM
This folder contains information and code on the ETL design and implementation process from staging db to OMOP CDM, descriptive statistics and data quality checks against an OMOP CDM instance.

The steps follow a chronological order as below:

## 1. Mapping document
Two closely-integrated tools have been developed to support the ETL design process: `White Rabbit`, and `Rabbit-in-a-Hat`.

### White Rabbit
To initiate an ETL process on a database you need to understand your data, including the tables, fields, and content. This is where the White Rabbit tool comes in. White Rabbit is a software tool to help prepare for ETLs of longitudinal healthcare databases into the OMOP CDM. White Rabbit scans your data and creates a report containing all the information necessary to begin designing the ETL. 

Process Overview: The typical sequence for using the software to scan source data:

- Set working folder, the location on the local desktop computer where results will be exported.
- Connect to the source database or CSV text file and test connection.
- Select the tables of interest for the scan and scan the tables.
- White Rabbit creates a **Scan Report** (an export of information about the source data).

### Rabbit in a Hat
Rabbit-In-a-Hat is designed to read and display a White Rabbit scan document. White Rabbit generates information about the source data while Rabbit-In-a-Hat uses that information and through a graphical user interface to allow a user to connect source data to tables and columns within the CDM. Rabbit-In-a-Hat generates documentation for the ETL process, it does not generate code to create an ETL.

Process Overview: The typical sequence for using this software to generate documentation of an ETL:

- Scanned results from WhiteRabbit completed.
- Open scanned results; interface displays source tables and CDM tables.
- Connect source tables to CDM tables where the source table provides information for that corresponding CDM table.
- For each source table to CDM table connection, further define the connection with source column to CDM column detail.
- Save Rabbit-In-a-Hat work and export to a MS Word document.

ETL design and implementation process from staging db to OMOP CDM can be found in the [1. mapping document](./1.%20mapping%20document) folder.

## 2. ETL staging to OMOP


## 3. Achilles
Achilles is part of [HADES](https://ohdsi.github.io/Hades/index.html) set collection of open-source R packages.

Achilles (Automated Characterization of Health Information at Large-Scale Longitudinal Evidence Systems) provides descriptive statistics, characterization and visualization of an OMOP CDM database. ACHILLES currently supports CDM version 5.3 and 5.4.

It is a critical resource to evaluate the composition of CDM databases.

Code for running Achilles analysis on the 14 OMOP CDM instances can be found in the [3. Achilles](./3.%20Achilles) folder.

## 4. Data Quality Dashboard
Data Quality Dashboard is part of [HADES](https://ohdsi.github.io/Hades/index.html) set collection of open-source R packages.

It applies a harmonized data quality assessment to data that has been standardized in the OMOP Common Data Model. This package will run a series of data quality checks against an OMOP CDM instance (currently supports v5.4, v5.3 and v5.2). It systematically goes table by table and field by field to quantify the number of records in a CDM that do not conform to the given specifications and evaluates the checks against some pre-specified threshold. Over 1,500 checks are performed, each one organized into the `Kahn framework`.

Code for running Data Quality Dashboard on the 14 OMOP CDM instances can be found in the [4. Data Quality Dashboard](./4.%20Data%20Quality%20Dashboard) folder.








