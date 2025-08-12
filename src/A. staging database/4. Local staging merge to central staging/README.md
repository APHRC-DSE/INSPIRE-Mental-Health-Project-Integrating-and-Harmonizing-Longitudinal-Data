# MH Local staging merge to Central Staging
Automate the process of moving different local versions of staging to a central staging warehouse

1. Dynamically generate local table with updated ID column in accordance with central staging databaser

2. Understand and link new primary and foreign keys where the changing primary key after step 1 needs to be updated on subsequent tables.
    - This is achieved by getting a list of tables FK that needs updating based on changing PK
    - A script to manage the update of the FK based on PK
    - Other non-affected columns and tables are maintained
3. Preferably test the whole pipeline with fewer rows like the study 1


**To Run Merge Script**

 1. Clone the repository to preferred location

 2. Create virtual environment `python3 -m venv myvenv`

 3. Activate `source myvenv/bin/activate` assumes running on Linux

 4. Install needed packages `pip3 install -r requirements.txt`

 5. Update the database credentials to match your staging database - specific_study DB and Merged/central DB

 6. RUN `python3 main.py`
