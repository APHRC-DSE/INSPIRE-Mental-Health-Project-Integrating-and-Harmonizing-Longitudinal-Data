# Schema.org Guide for the INSPIRE MH DataHub

---
> [!NOTE]
Entries have properties based on the schema.org Dataset type which borrows from Dublin Core, DCAT, and other specifications. The primary goal is to make mental health data FAIR: Findable, Accessible, Interoperable, and Reusable.

>[!TIP]
>Entries are just the metadata. They describe the data but do not contain the sensitive patient-level information itself.

>[!IMPORTANT]
>We are in the process of identifying which properties are necessary and which are optional. This guide represents our current best practices.
>


---
## Table of Contents

- [Getting Started...](#getting-started)
- [Capture Core Discovery Metadata](#capture-core-discovery-metadata)
- [Start with the Dataset Backbone](#start-with-the-dataset-backbone)
- [Define Standard Properties](#define-standard-properties-name-description-keywords) (`name`, `description`, `keywords`, etc.)
- [Link the Main Entity](#link-the-main-entity-mainentity) (`mainEntity`)
- [Embed in a Data Catalog](#embed-in-a-data-catalog-includedindatacatalog) (`includedInDataCatalog`)
- [Reference Source Material](#reference-source-material-isbasedon) (`isBasedOn`)
- [Connect to Related Works](#connect-to-related-works-subjectof) (`subjectOf`)
- [Specify Spatial Coverage](#specify-spatial-coverage-spatialcoverage) (`spatialCoverage`)
- [Specify Temporal Coverage](#specify-temporal-coverage-temporalcoverage) (`temporalCoverage`)
- [Define Distribution Channels](#define-distribution-channels-distribution) (`distribution`)
- [Model Variables Properly](#model-variables-properly-variablemeasured) (`variableMeasured`)
  - [Use PropertyValue for Individual-Level Clinical Concepts](#use-propertyvalue-for-individual-level-clinical-concepts) (`PropertyValue`)
  - [Use StatisticalVariable for Aggregate Measures](#use-statisticalvariable-for-aggregate-measures) (`StatisticalVariable`)
  - [Add Patient-Reported Outcomes (PRO) Example](#add-patient-reported-outcomes-pro-example)
- [Describe About, Events, and Actions](#describe-about-events-and-actions)
- [Assign Persistent Identifiers](#assign-persistent-identifiers-identifier) (`identifier`)
- [Declare Access, Licensing, and Governance](#declare-access-licensing-and-governance)
- [Record Provenance and Versioning](#record-provenance-and-versioning)
- [Use the Checklist Before Publishing](#use-the-checklist-before-publishing)

--- 

## Getting Started...
...

## Capture Core Discovery Metadata
Standard properties including `name`, `description`, `dateCreated`, `dateModified`, `datePublished`, `license`, `citation`, `version`, `keywords`, `measurementTechnique`, `measurementMethod`, `creator`, `funder`, and `provider`.

*   **For `creator` and `contributor`:** Use the `Role` pattern to specify detailed contributor roles (e.g., "Principal Investigator", "Data Curator"). [See here for a detailed example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#roles-of-people).
*   **For `citation`:** If a publication describes the dataset or its methodology, use a `ScholarlyArticle` object instead of plain text to create a rich, machine-readable link. *Example: The [INSPIRE methodology paper](https://doi.org/10.3389/fdata.2024.1435510) should be cited this way.*

...

## Start with the Dataset Backbone

### Define Standard Properties (name, description, keywords)

...

### Link the Main Entity (mainEntity)

...

### Embed in a Data Catalog (includedInDataCatalog)

...

### Reference Source Material (isBasedOn)

...

### Connect to Related Works (subjectOf)

...

### Specify Spatial Coverage (spatialCoverage)

...

### Specify Temporal Coverage (temporalCoverage)

...

### Define Distribution Channels (distribution)

...

## Model Variables Properly (variableMeasured)

### Use PropertyValue for Individual-Level Clinical Concepts

...

### Use StatisticalVariable for Aggregate Measures

...

### Add Patient-Reported Outcomes (PRO) Example

...

## Describe About, Events, and Actions

...

## Assign Persistent Identifiers (identifier)

...

## Declare Access, Licensing, and Governance

...

## Record Provenance and Versioning

...

## Use the Checklist Before Publishing

...



