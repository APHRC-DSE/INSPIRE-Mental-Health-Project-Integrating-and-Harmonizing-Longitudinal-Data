### Schema.org Guide Implementation Checklist

> [!NOTE]
Use this checklist to implement Schema.org `Dataset` descriptions consistently and in alignment with FAIR principles.

#### Core Properties
- [ ] **Name & Description**: Add `name`, `description`, and `keywords`
- [ ] **Identifier**: Assign persistent `identifier` (DOI or similar)
- [ ] **References**: Include `isBasedOn` and `subjectOf` if applicable

#### Coverage Information
- [ ] **Spatial Coverage**: Define `spatialCoverage` (countries/regions)
- [ ] **Temporal Coverage**: Specify `temporalCoverage` (date range)

#### Variable Documentation
- [ ] **Variables List**: Populate `variableMeasured` with all variables
- [ ] **Individual Metadata**: Add `PropertyValue` for key variables
- [ ] **Aggregate Measures**: Include `StatisticalVariable` for statistics

#### Contextual Metadata
- [ ] **Topics**: Define primary `about` subjects
- [ ] **Events**: Link related `event` entities
- [ ] **Actions**: Specify supported `action` types

#### Enhanced Metadata
- [ ] **License**: Apply appropriate `license`
- [ ] **Creators**: Credit all `creator` organizations/people
- [ ] **Publisher**: Identify `publisher` entity
- [ ] **Funders**: Acknowledge `funder` organizations
- [ ] **Version**: Set current `version` number
- [ ] **Distribution**: Describe `distribution` methods

---

#### Priority Levels:
- **High**: Required properties (`name`, `description`, `identifier`)
- **Medium**: Recommended enhancements (`license`, `creator`, `version`)
- **Low**: Conditional properties (`isBasedOn`, `subjectOf`, contextual info)

#### Best Practices:
- Use consistent naming conventions
- Include both human-readable and machine-readable content
- Validate with [Schema.org Validator](https://validator.schema.org/)
- Test with Google's [Rich Results Test](https://search.google.com/test/rich-results)
