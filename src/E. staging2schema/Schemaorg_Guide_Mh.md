# Schema.org Guide for the INSPIRE MH DataHub

---
> [!NOTE]
Entries have properties based on the schema.org Dataset type which borrows from Dublin Core, DCAT, and other specifications. The primary goal is to make mental health data FAIR: Findable, Accessible, Interoperable, and Reusable.

>[!TIP]
>Entries are just the metadata. They describe the data but do not contain the sensitive patient-level information itself.

>[!IMPORTANT]
>We are in the process of identifying which properties are necessary and which are optional. This guide represents our current best practices.

## Core Dataset Properties for Discovery
Every dataset should be described using a JSON-LD script. The following properties are essential for basic discovery
- **DataCatalog** → Represents the staging database or hub.
- **Dataset** → Describes individual longitudinal studies or waves.
- **variableMeasured** → Two types: `PropertyValue` (metadata about variables) and `StatisticalVariable` (for statistical measures). 
- **DefinedTerm** → Connects variables to controlled vocabularies (SNOMED, LOINC, etc.).
- **CreativeWork / ScholarlyArticle** → Links datasets to related publications.
- **Person / Organization** → Identifies investigators, contributors, and funders.
- **identifier (PropertyValue)** → Provides persistent identifiers (DOI, registry IDs)

![Schema.org Metadata Guide Illustration](../../images/SchemaGuide.png)
*Figure 1: A conceptual diagram of the core schema.org types and their relationships for describing datasets.*

## Getting Started...

A `Dataset` in the INSPIRE DataHub is described using the following core properties.

### Standard Properties
Standard properties including `name`, `description`, `dateCreated`, `dateModified`, `datePublished`, `license`, `citation`, `version`, `keywords`, `measurementTechnique`, `measurementMethod`, `creator`, `funder`, and `provider`.

*   **For `creator` and `contributor`:** Use the `Role` pattern to specify detailed contributor roles (e.g., "Principal Investigator", "Data Curator"). [See here for a detailed example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#roles-of-people).
*   **For `citation`:** If a publication describes the dataset or its methodology, use a `ScholarlyArticle` object instead of plain text to create a rich, machine-readable link. *Example: The [INSPIRE methodology paper](https://doi.org/10.3389/fdata.2024.1435510) should be cited this way.*

---



