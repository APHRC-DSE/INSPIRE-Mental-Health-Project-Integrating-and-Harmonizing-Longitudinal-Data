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

### Standard Properties
Standard properties including `name`, `description`, `dateCreated`, `dateModified`, `datePublished`, `license`, `citation`, `version`, `keywords`, `measurementTechnique`, `measurementMethod`, `creator`, `funder`, and `provider`.

*   **For `creator` and `contributor`:** Use the `Role` pattern to specify detailed contributor roles (e.g., "Principal Investigator", "Data Curator"). [See here for a detailed example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#roles-of-people).
*   **For `citation`:** If a publication describes the dataset or its methodology, use a `ScholarlyArticle` object instead of plain text to create a rich, machine-readable link. *Example: The [INSPIRE methodology paper](https://doi.org/10.3389/fdata.2024.1435510) should be cited this way.*

### mainEntity
Indicates the primary entity described in the dataset. For clinical data, this is overwhelmingly the **`Person`** (the patient or research subject).

*   Use `additionalProperty` to describe the cohort definition, as the `mainEntity` itself is a generic placeholder.
*   **INSPIRE Recommendation:** Add a `PropertyValue` with `name="cohort_definition"` to provide a clear, textual description of the study population.
    *   **Example:** `"Adolescents aged 12-18 with a primary diagnosis of major depressive disorder"`

### includedInDataCatalog
A data catalog which contains this dataset.

*   **Our data catalog is named the `INSPIRE DataHub`.**
    ```json
    "includedInDataCatalog": {
      "@type": "DataCatalog",
      "name": "INSPIRE DataHub",
      "url": "https://datahub.inspirenetwork.org"
    }
    ```

### isBasedOn
A resource from which this work is derived or a modification/adaptation. This is **critical for provenance**.

*   Can take the form of an array of resources. For INSPIRE, this typically includes:
    1.  **Source raw data** (e.g., `{"@type": "Dataset", "name": "Raw EHR Export from Site A"}`).
    2.  **Study Protocol** (e.g., `{"@type": "CreativeWork", "name": "INSPIRE Study Protocol v2.1", "version": "2.1"}`).
    3.  **A previous version** of the dataset.
*   See [here](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#indicating-a-source-dataset-schemaisbasedon-and-provwasderivedfrom) for an example. We also recommend using `prov:wasDerivedFrom` from the PROV ontology for stronger provenance semantics.

### subjectOf
A `Claim` about this dataset. Think of the `Claim(s)` a Dataset makes as its **hypotheses or primary research questions**.

*   Minimally, a claim has an `appearance` that indicates an occurrence in some `CreativeWork` (e.g., a pre-registration, published paper).
*   Can take the form of an array of claims.
*   **INSPIRE Recommendation:** Use this to link the data to the research questions it aims to answer, enhancing scientific clarity.

### spatialCoverage
The spatial coverage of a CreativeWork takes the place(s) which are the focus of the content.

*   A spatialCoverage may take an array of `Place` for multi-site studies.
*   A `Place` takes a `name`, a `description`, and a `geo`.
*   A `geo`, in turn, takes:
    *   `GeoCoordinates` ([See example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#use-geocoordinates-for-point-locations)) for specific site locations.
    *   `GeoShape` ([See example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#use-geoshape-for-all-other-location-types)) for representing catchment areas.
*   Use `additionalProperty` to identify the spatial reference system (e.g., WGS84). [See here for an example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#spatial-reference-systems).

### temporalCoverage
`temporalCoverage` is expressed in ISO 8601 format. For longitudinal studies, use a date interval.

*   **Example:** `"2018-01-01/2023-12-31"`
*   **For individual variables,** use `variableMeasured[*].additionalProperty` to specify `timepoint` or `assessmentDate` for each measurement wave, providing granular temporal context.

### distribution
A downloadable form of this dataset, at a specific location, in a specific format.

*   **Takes either a `DataDownload` or a `SearchAction`**.
    *   Takes a `DataDownload` when a distribution can be retrieved by a URL. [See here for an example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#distributions). *Suitable for aggregate data packages.*
    *   Takes a `SearchAction` when the distribution is retrieved through a service endpoint that takes query parameters. [See here for an example](https://github.com/ESIPFed/science-on-schema.org/blob/main/guides/Dataset.md#accessing-data-through-a-service-endpoint). ***This is the preferred method for a staging server,** allowing for cohort exploration via tools like OHDSI ATLAS or FHIR APIs.*

### variableMeasured (The Core of Clinical Data)
The `variableMeasured` property is the most important for clinical interoperability. It can take two forms, and the choice is critica

#### 1. `PropertyValue` (For Individual-Level Clinical Concepts)
**Use this for:** Direct measurements, observations, or concepts recorded for each individual subject.

**Core Properties:**
*   **`name`:** The variable name (e.g., `phq9_total_score`, `fasting_glucose`).
*   **`description`:** A human-readable definition of the variable.
*   **`valueReference` (CRUCIAL):** Use `DefinedTerm` to **semantically anchor** the variable to a concept in a **controlled vocabulary** (OMOP, SNOMED, LOINC, DDI). This provides the *what*.
*   **`measurementTechnique`:** The instrument or method (e.g., "PHQ-9", "HAM-D", "Blood assay"). This describes the *how*.
*   **`minValue` / `maxValue`:** For numeric variables, the theoretical or observed range.

**Advanced QUDT Properties (Recommended for Quantitative Data):**
For precise machine-interpretability of measurements, define the QUDT context and use its properties. This is superior to a simple `unitCode`.
*   **`qudt:dataType`:** The XML Schema Definition (XSD) data type of the value (e.g., `xsd:decimal`, `xsd:integer`, `xsd:float`).
*   **`qudt:quantityKind`:** The type of quantity being measured (e.g., `quantitykind:Concentration`, `quantitykind:Mass`, `quantitykind:Length`).
*   **`qudt:unit`:** The specific unit of measurement from the QUDT vocabulary (e.g., `unit:MilliGM-PER-dL`, `unit:MilliMOL-PER-L`).

*   **`additionalProperty`:** For longitudinal metadata (`timepoint`, `wave`, `protocolVersion`) or other context.

**Example: A Semantically Rich Lab Measurement Variable**
```json
{
  "@context": {
    "@vocab": "https://schema.org/",
    "qudt": "http://qudt.org/schema/qudt/",
    "quantitykind": "http://qudt.org/vocab/quantitykind/",
    "unit": "http://qudt.org/vocab/unit/",
    "xsd": "http://www.w3.org/2001/XMLSchema#"
  },
  "@type": "PropertyValue",
  "name": "creatinine_serum",
  "description": "The level of creatinine in the patient's blood, a key indicator of kidney function.",
  "valueReference": {
    "@type": "DefinedTerm",
    "inDefinedTermSet": "LOINC",
    "termCode": "2160-0",
    "name": "Creatinine [Mass/volume] in Serum or Plasma"
  },
  "measurementTechnique": "Blood assay",
  "minValue": 0.2,
  "maxValue": 15.0,
  "qudt:dataType": "xsd:decimal",
  "qudt:quantityKind": "quantitykind:Concentration",
  "qudt:unit": "unit:MilliGM-PER-dL"
}
### Summary of Use Cases

| Your Data Is... | Use This Type | Example |
| :--- | :--- | :--- |
| **Individual-level** measurements | `PropertyValue` | A patient's PHQ-9 score, a diagnosis code, a lab value. |
| **Aggregate** statistics | `StatisticalVariable` | The prevalence of MDD in 2022, the average HbA1c by region. |

