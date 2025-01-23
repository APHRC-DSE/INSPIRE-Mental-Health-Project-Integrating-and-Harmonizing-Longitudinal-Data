# INSPIRE-Mental-Health-Project-Integrating-and-Harmonizing-Longitudinal-Data
This repository contains project resources for building a data science platform for integration and harmonization of longitudinal data on mental health in Africa.

## Summary
Longitudinal studies are essential for understanding the progression of mental health disorders over time, but combining data collected through different methods to assess conditions like depression, anxiety, and psychosis presents significant challenges. This project will utilize a mapping technique allowing for the conversion of diverse longitudinal data into a standardized staging database, leveraging the Data Documentation Initiative (DDI) Lifecycle and the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) standards to ensure consistency and compatibility across datasets.

The “INSPIRE” project integrates longitudinal data from African studies into a staging database using metadata documentation standards structured with a snowflake schema. This facilitates the development of Extraction, Transformation, and Loading (ETL) scripts for integrating data into OMOP CDM. The staging database schema is designed to capture the dynamic nature of longitudinal studies, including changes in research protocols and the use of different instruments across data collection waves. Utilizing the staging database will streamline the data migration process enabling subsequent integration into the OMOP CDM. Adherence to metadata standards ensures data quality, promotes interoperability, and expands opportunities for data sharing in mental health research.

The staging database serves as an innovative tool in managing longitudinal mental health data, going beyond simple data hosting to act as a comprehensive study descriptor. It provides detailed insights into each study stage and establishes a data science foundation for standardizing and integrating the data into OMOP CDM.

## Primary deliverables

- **D1:** Discover new and existing data from population and clinical data sources on: longitudinal African mental health (mental health) conditions; mental health signs, symptoms and biomarkers; mental health treatment interventions in the African context; and mental health risk factors in Africa. 
- **D2:** Integrate and augment the vocabularies by mental health researchers in the metadata used by data science applications to FAIRly described mental health observations in Africa. 
- **D3:** Provide a dashboard and central catalog that can be used worldwide to discover and characterize African mental health conditions.
- **D4:** Identify and answer key questions about causes and management of mental health in African settings through cohorts identified in the OMOP database. 
- **D5:** Conduct advanced causal inferential analyses on the impact of community, household and environmental exposures on mental health across a federated cloud-based environment on the East Africa data web.

## Repo Structure

Inspired by [Cookie Cutter Data Science](https://github.com/drivendata/cookiecutter-data-science).

```
├── LICENSE
├── README.md              <- The top-level README for users of this project.
├── CODE_OF_CONDUCT.md     <- Guidelines for users and contributors of the project.
├── CONTRIBUTING.md        <- Information on how to contribute to the project.
├── CHANGES.md             <- Information on summary of changes made in this repository
│
├── images                 <- Images folder for any images to be used in the README files
│
├── data                   <- Delivarable 1: A brief description of how we obtained the datasets and how they can be accessed. 
│   ├── primary        
│   └── secondary      
│
├── project_management     <- Meeting notes and other project planning resources
│
├── src                    <- Delivarable 2 - 5: Source code for use in this project.
│   │
│   ├── staging database   
│   │   │                 
│   │   ├── staging db              <- Documentation on design and creation of the staging database
│   │   ├── metadata                <- Files generated for various staging db tables
│   │   ├── ETL source to staging   <- Source code on ETL of various data using the various tools. i.e SQL, Python, Pentaho.
│   │   ├── merge csv dumps         <- Merging all ETL population studies to staging
│   │   └── metabase dashboard
│   │
│   ├── OMOP-CDM           <- ETL from staging to OMOP
│   │   │                 
│   │   ├── Mapping                 <- Staging to OMOP Mapping document
│   │   └── ETL staging to OMOP
│   │
│   └── ATLAS Analysis     <- Exploratory and results-oriented analysis and visualization
│   
└──
```

## Maintainers

This repository has been set up and maintained by [Bylhah Mugotitsa ](https://github.com/BeeMugo9) and [Reinpeter Momanyi](https://github.com/reinpmomz) to centralise resources used, developed and maintained under the project.

♻️ License
---

This work is licensed under the MIT license (code) and Creative Commons Attribution 4.0 International license (for documentation).
You are free to share and adapt the material for any purpose, even commercially, as long as you provide attribution (give appropriate credit, provide a link to the license,
and indicate if changes were made) in any reasonable manner, but not in any way that suggests the license or endorses you or your use and with no additional restrictions.

🤝 Acknowledgement
---

This repository uses the template created by Malvika and members of *The Turing Way* team, shared under CC-BY 4.0 for reuse: https://github.com/the-turing-way/reproducible-project-template.

## Contributors ✨

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):


