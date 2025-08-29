# Schema.org Metadata Guide for Longitudinal Mental Health Data

---

## Purpose
This guide provides a framework for creating `schema.org` metadata for datasets stored in the **INSPIRE Network staging server**, which hosts **longitudinal mental health data and metadata**. It draws on:
The goal is to make metadata **standardized, discoverable, interoperable, and reusable**, aligned with the **FAIR principles**.

![Schema.org Structure Diagram](images/SchemaGuide.png)
*Figure 1: A conceptual diagram of the core schema.org types and their relationships for describing datasets.*

## Core Dataset Properties for Discovery
Every dataset should be described using a JSON-LD script. The following properties are essential for basic discovery
- **DataCatalog** → Represents the staging database or hub.
- **Dataset** → Describes individual longitudinal studies or waves.
- **variableMeasured (PropertyValue)** → Describes dataset variables.
- **DefinedTerm** → Connects variables to controlled vocabularies (DDI, OMOP, SNOMED, LOINC, etc.).
- **CreativeWork / ScholarlyArticle** → Links datasets to related publications.
- **Person / Organization** → Identifies investigators, contributors, and funders.
- **identifier (PropertyValue)** → Provides persistent identifiers (DOI, registry IDs)

