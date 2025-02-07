# Provides a summary of the updates made to the Staging database 


## Jan 26 2025 - Feb 3 2025

### Instrument Table

- The values of the `instrument_type_concept_id` were changed from _601_ to the **concept id of the tool being used**.  

### Instrument Item Table

- The datatype of the column `instrument_item_type_concept_id` was changed from _integer_ to **bigint**.

- The datatype of the column `alternative_instrument_item_concept_vocabulary_id` was changed from _integer_ to **bigint**.

### Population study Table

- A new column `data_source` was introduced to capture different data sources.

### Concept Table

- A new column `domain` was introduced to capture the domains of the concepts.

