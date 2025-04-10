# INSPIRE-Mental-Health-Project-Integrating-and-Harmonizing-Longitudinal-Data
This repository contains project resources for building a data science platform for integration and harmonization of longitudinal data on mental health in Africa.

## Summary
The **INSPIRE: Building a Data Science Platform for Integration and Harmonization of Longitudinal Data on Mental Health in East Africa project** is designed to improve mental health outcomes for depression, anxiety and psychosis in East African settings, specifically in Kenya. To do this, the project aims to provide mental health datasets from African researches to help ensure data-driven decision making on mental health conditions.

Historically, public health policymakers in Africa have focused on communicable diseases, such as malaria, tuberculosis, and HIV/AIDS. However, non-communicable diseases, such as cancer, heart disease, diabetes, and mental health conditions are increasingly becoming the main cause of mortality in Africa.

There is a continuous need for essential data on mental health prevalence and services in East Africa to assist in improving the appropriateness and accuracy of mental health screenings and to develop a more nuanced and culturally appropriate mental health database. Data on the causes, consequences, and impacts of mental health conditions in the African population, therefore, needs to be collected and harmonized. This data needs to capture and account for physical exposures, socio-economic forces, health opportunities , and lifestyles, often referred to as the external exposome, which impact mental health. This necessitates data from longitudinal research, which could also show the effectiveness of interventions to improve mental health in the Kenyan Region of East Africa.

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
├── assets                 <- Folder for evidence products  
│
├── data                   <- Delivarable 1: A brief description of how we obtained the datasets and
│                             how they can be accessed.  
│   ├── primary        
│   └── secondary      
│
├── project_management     <- Project planning resources
│   ├── communication
│   ├── people folder
│   ├── policies
│   ├── project planning
│   ├── project proposals
│   ├── project reports           
│   └── workshops
│
├── src                    <- Delivarable 2 - 5: Source code for use in this project.
│   │
│   ├── A. staging database   
│   │   │                 
│   │   ├── 1. staging db              <- Documentation on design and creation of staging database
│   │   ├── 2. metadata                <- Files generated for various staging db tables
│   │   ├── 3. ETL-source to staging   <- Source code on ETL of various data using the various tools.
│   │   │                                  i.e SQL, Python, Pentaho.
│   │   │   │
│   │   │   ├── population_study_id_1              
│   │   │   ├── population_study_id_2             
│   │   │   ├── population_study_id_3             
│   │   │   ├── population_study_id_4              
│   │   │   ├── population_study_id_5             
│   │   │   ├── population_study_id_6
│   │   │   ├── population_study_id_7              
│   │   │   ├── population_study_id_8             
│   │   │   ├── population_study_id_9             
│   │   │   ├── population_study_id_10              
│   │   │   ├── population_study_id_11
│   │   │   ├── population_study_id_12
│   │   │   ├── population_study_id_13               
│   │   │   └── population_study_id_14
│   │   │                                                 
│   │   ├── 4. merge dumps         <- Merging all ETL population studies to central staging
│   │   └── 5. metabase dashboard
│   │
│   ├── B. OMOP-CDM           <- ETL from staging to OMOP
│   │   │                 
│   │   ├── 1. mapping document           <- Staging to OMOP Mapping document
│   │   ├── 2. ETL staging to OMOP        <- Source code on ETL
│   │   │   │
│   │   │   ├── Pentaho
│   │   │   ├── R
│   │   │   └── Python
│   │   │         
│   │   ├── 3. Achilles                   
│   │   └── 4. Data Quality Dashboard
│   │   │          
│   └── C. ATLAS Analysis     <- Exploratory and results-oriented analysis and visualization
└──
```

## Maintainers

This repository has been set up and maintained by [Bylhah Mugotitsa ](https://github.com/BeeMugo9) and [Reinpeter Momanyi](https://github.com/reinpmomz) to centralise resources used, developed and maintained under the project.

♻️ License
---

This work is licensed under the MIT license (code) and Creative Commons Attribution 4.0 International license (for documentation).
You are free to share and adapt the material for any purpose, even commercially, as long as you provide 
attribution (give appropriate credit, provide a link to the license, and indicate if changes were made) in any reasonable
manner, but not in any way that suggests the license or endorses you or your use and with no additional restrictions.

🤝 Acknowledgement
---

This repository uses the template created by Malvika and members of *The Turing Way* team, shared under CC-BY 4.0 for reuse: https://github.com/the-turing-way/reproducible-project-template.

## Contributors ✨

Thanks goes to these wonderful people:

| **Emoji Type/Represents** | **Role** | **Contributor** | **Institution** | **Profile Link** |
|---|---|---|---|---|
| 💵 `Financial` | Financial Support | Wellcome Trust | Wellcome Trust | https://wellcome.org/ |
| 🔍 `Grant Finders` | Principal Investigator | Agnes Kiragga | African Population & Health Research Centre (APHRC) | |
| 🔍 `Grant Finders` | Principal Investigator | Jim Todd | London School of Hygiene & Tropical Medicine |  |
| 📆 `Project Management` <br /> 🔬 `Research` | Project management and research | Bylhah Mugotitsa | African Population & Health Research Centre (APHRC) |  |
| 🤔 `Ideas` <br /> 👀  `Review` | Ideas & review | Emma Slaymaker | London School of Hygiene & Tropical Medicine |  |
| 🤔 `Ideas` <br /> 🎨 `Design`  <br /> 👀  `Review` <br /> 🔣 `Analysis` | Ideas, staging database design, review & Atlas analysis | Jay Greenfield | Committee Data of the International Science Council  (CODATA) | |
| 🤔 `Ideas` <br /> 🎨 `Design`  <br /> 👀  `Review` <br /> 💻 `code` | Ideas, staging database design, review & ETLs | Tathagata Bhattacharjee | London School of Hygiene & Tropical Medicine |  |
|  🚇 `Infrastructure` <br /> 📦 `platform` <br /> 💻 `code` | Build-Tools i.e staging database, visualization platform & ETLs | Dorothy Mailosi | Committee Data of the International Science Council  (CODATA) |  |
|  🚇 `Infrastructure` <br /> 📦 `platform` <br /> 💻 `code` | Build-Tools i.e staging database, visualization platform & ETLs | Michael Ochola | African Population & Health Research Centre (APHRC) | |
| 📖 `doc` <br /> 💻 `code` | Documentation of project & ETLs | David Amadi | London School of Hygiene & Tropical Medicine | |
| 📖 `doc` <br /> 💻 `code` | Documentation of project & ETLs | Reinpeter Ondeyo | African Population & Health Research Centre (APHRC) | |
| 💻 `code` <br /> 🔣 `analysis` | ETLs & Atlas analysis | Pauline Andeso | African Population & Health Research Centre (APHRC) | |
| 💻 `code` | ETLs | Joseph Kuria | African Population & Health Research Centre (APHRC) | |

