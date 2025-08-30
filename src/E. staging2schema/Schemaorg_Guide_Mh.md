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
- [Capture Core Discovery Metadata](#capture-core-discovery-metadata)  
- [Getting Started](#getting-started)
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
## Capture Core Discovery Metadata

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
...

## Getting Started...

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



