# staging2schema.org
 
**staging2schema.org** is a toolset designed to generate [Schema.org](https://schema.org/) `Dataset` descriptions directly from a staging database. The goal is to make data and metadata hosted in a staging server **machine-readable**, **FAIR-compliant**.  

This work is inspired by and builds upon the principles of data standardization and harmonization discussed in the paper:  

*Mugotitsa, B., Amadi, D. K., et al. (2024). Integrating longitudinal mental health data into a staging database: harnessing DDI-lifecycle and OMOP vocabularies within the INSPIRE Network Datahub. Frontiers in Big Data, 7.*  
[Read the paper here](https://www.frontiersin.org/journals/big-data/articles/10.3389/fdata.2024.1435510/full)  

---

## Features  
- Connects to a staging database (PostgreSQL supported, extendable to others).  
- Extracts both **data** and **metadata** from the source system.  
- Transforms metadata into Schema.org `Dataset` JSON-LD format.  
- Provides reusable scripts in **R**   

---
## Project Structure  

