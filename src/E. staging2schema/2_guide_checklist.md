### 🗂️ Schema.org Dataset Metadata Guide (Checklist)

---
### ✅ Core Standard Properties
| Property | Description | Priority |
|----------|------------|----------|
| `name` | Dataset title | Required ✅ |
| `description` | Detailed summary | Required ✅ |
| `keywords` | Search terms for discovery | Required ✅ |
| `identifier` | Persistent ID (DOI, etc.) | Required ✅ |
| `isBasedOn` | Source reference | Recommended ⚠️ |
| `subjectOf` | Related works | Recommended ⚠️ |

- [ ] **Identity**: `name`, `description`, `keywords`  
- [ ] **Persistent Identifier**: `identifier`  
- [ ] **Source Reference**: `isBasedOn`  
- [ ] **Related Works**: `subjectOf`  

---

### 🌍 Coverage Metadata
| Property | Description | Priority |
|----------|------------|----------|
| `spatialCoverage` | Geographic coverage | Recommended ⚠️ |
| `temporalCoverage` | Time period coverage | Recommended ⚠️ |

- [ ] **Spatial Coverage**: `spatialCoverage`  
- [ ] **Temporal Coverage**: `temporalCoverage`  

---

### 📊 Variable Documentation
| Property | Description | Priority |
|----------|------------|----------|
| `variableMeasured` | Variables captured in the dataset | Required ✅ |
| `PropertyValue` | Individual-level variable metadata | Recommended ⚠️ |
| `StatisticalVariable` | Aggregate measures | Recommended ⚠️ |

- [ ] **Variable Metadata**: `variableMeasured`  
- [ ] **Individual-level Concepts**: `PropertyValue`  
- [ ] **Aggregate Measures**: `StatisticalVariable`  

---

### 🔍 Contextual Information
| Property | Description | Priority |
|----------|------------|----------|
| `about` | Primary topics | Recommended ⚠️ |
| `event` | Related events | Recommended ⚠️ |
| `action` | Associated actions | Recommended ⚠️ |

- [ ] **About / Events / Actions**: `about`, `event`, `action`  

---

### ⭐ Recommended Enhancements
| Property | Description | Priority |
|----------|------------|----------|
| `license` | Usage rights | High 🔥 |
| `creator` | Dataset authors | High 🔥 |
| `publisher` | Publishing entity | High 🔥 |
| `funder` | Funding sources | High 🔥 |
| `version` | Version number | High 🔥 |
| `distribution` | Access methods | High 🔥 |

- [ ] **License**: `license`  
- [ ] **Creators, Publishers, Funders**: `creator`, `publisher`, `funder`  
- [ ] **Versioning**: `version`  
- [ ] **Distribution Details**: `distribution`  

---

💡 **Tips for Learners:**
- Check off each item as you implement it to track progress.  
- Focus on **Required ✅** fields first for minimum compliance.  
- Use **High 🔥** recommended fields to enhance FAIRness.  
- Refer to `guide_full.md` for detailed explanations and examples.
