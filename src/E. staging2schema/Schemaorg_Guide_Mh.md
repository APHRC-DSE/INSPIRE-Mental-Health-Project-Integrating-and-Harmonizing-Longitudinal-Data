# Schema.org Metadata Guide for Longitudinal Mental Health Data

---
[!NOTE]
Entries have properties based on the schema.org Dataset type which borrows from Dublin Core, DCAT, and other specifications. The primary goal is to make mental health data FAIR: Findable, Accessible, Interoperable, and Reusable.

[!TIP]
Entries are just the metadata. They describe the data but do not contain the sensitive patient-level information itself.

[!IMPORTANT]
Entries must include instructions for retrieving the actual data or for requesting access through a governed process.

[!WARNING]
We are in the process of identifying which properties are necessary and which are optional. This guide represents our current best practices.

## Purpose
This guide provides a framework for creating `schema.org` metadata for datasets stored in the INSPIRE Network staging server, which hosts longitudinal mental health data and metadata.
The goal is to make metadata standardized, discoverable, interoperable, and reusable, aligned with the FAIR principles.

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

Let's begin...

A Dataset in the INSPIRE DataHub has the following standard properties:

* `name`
* `description`
* `dateCreated`
* `dateModified`
* `datePublished`
* `license`
* `citation`
* `version`
* `keywords`
* `measurementTechnique`
* `measurementMethod`
* `creator`
* `funder`
* `provider`

For an example of `creator` using the `Role` type, see the schema.org documentation or JSON-LD examples.


