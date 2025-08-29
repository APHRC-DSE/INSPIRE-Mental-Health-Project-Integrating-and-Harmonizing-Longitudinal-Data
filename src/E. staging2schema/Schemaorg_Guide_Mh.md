# Schema.org Metadata Guide for Longitudinal Mental Health Data

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

# Schema.org Guide for the INSPIRE DataHub

## Let's begin...

A `Dataset` in the INSPIRE DataHub is described using a set of core properties. The following are the essential elements to include.

### 1. Standard Properties

These are the foundational metadata properties for discovery and citation.

| Property | Type | Description & Example |
| :--- | :--- | :--- |
| **`name`** | Text | A descriptive title for the dataset.<br/>**Example:** `"INSPIRE Global Cohort: Longitudinal Adolescent Depression Data (Wave 1)"` |
| **`description`** | Text | A rich, concise summary of the dataset's content, scope, and purpose.<br/>**Example:** `"Baseline data for a multi-site cohort study tracking depression symptoms in adolescents aged 12-18, including PHQ-9 scores and demographic information."` |
| **`dateCreated`** | DateTime | The date the dataset was initially generated.<br/>**Example:** `"2023-01-15T08:00:00Z"` |
| **`dateModified`** | DateTime | The date the dataset was most recently updated or changed.<br/>**Example:** `"2023-06-20T14:30:00Z"` |
| **`datePublished`** | DateTime | The date when the dataset was made available on the DataHub.<br/>**Example:** `"2023-06-25T09:15:00Z"` |
| **`license`** | URL | The license under which the dataset is published. Use SPDX URLs for machine-readability.<br/>**Example:** `"https://spdx.org/licenses/CC-BY-4.0"` |
| **`citation`** | Text or CreativeWork | The recommended citation for the dataset. Can be text or a `ScholarlyArticle` object if a publication exists.<br/>**Example (Text):** `"INSPIRE Network (2023). INSPIRE Global Cohort: Wave 1 [Data set]. INSPIRE DataHub. https://doi.org/10.1234/INSPIRE.2023-001"` |
| **`version`** | Text | The version number or identifier for this dataset.<br/>**Example:** `"1.2"` or `"2023-06-25"` |
| **`keywords`** | Text or DefinedTerm | Key terms to aid discovery. **Strongly recommend using `DefinedTerm` to link to controlled vocabularies** like OMOP or MeSH.<br/>**Example:** <br>`["mental health", "adolescent", "longitudinal"]` <br> or <br> `{ "@type": "DefinedTerm", "inDefinedTermSet": "OMOP", "termCode": "44159003", "name": "Major depressive disorder" }` |
| **`measurementTechnique`** | Text | The instrument or tool used to collect the data.<br/>**Example:** `"PHQ-9"`, `"Electronic Health Record"`, `"fMRI"` |
| **`measurementMethod`** | Text | The procedure or protocol used in the measurement.<br/>**Example:** `"Self-reported questionnaire administered in clinic"` |
| **`creator`** | Person or Organization | The entity responsible for creating the dataset. Use the `Role` pattern for detailed contributor roles. <br> **[See here for an example of `creator` using the `Role` type.](#example-creator-using-role)** |
| **`funder`** | Person or Organization | The organization or person that provided financial support for the work.<br/>**Example:** `{ "@type": "Organization", "name": "National Institute of Mental Health" }` |
| **`provider`** | Person or Organization | The service provider, publishing, or hosting organization—typically the INSPIRE Network itself.<br/>**Example:** `{ "@type": "Organization", "name": "The INSPIRE Network" }` |

---

### Example: Creator using Role

<a id="example-creator-using-role"></a>
```json
"creator": [
  {
    "@type": "Role",
    "roleName": "Principal Investigator",
    "creator": {
      "@type": "Person",
      "name": "Dr. Researcher Name",
      "identifier": {
        "@type": "PropertyValue",
        "propertyID": "orcid",
        "value": "0000-0002-1825-0097"
      }
    }
  }
]





