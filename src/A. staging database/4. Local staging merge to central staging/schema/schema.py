# The following shema represent tables that the primary and foreign key needs to be updated to align with the central staging
staging_tables = {"location":[
                                    "location_id",
                                    "village_name",
                                    "place_kind",
                                    "latitude",
                                    "longitude"
                            ],

                  "household":[
                                    "household_id",
                                    "household_id_value",
                                    "location_id",
                                    "household_head_id"                    


                              ],
                    "resident_episode":[
                                    "resident_episode_id",
                                    "location_id",
                                    "household_id",
                                    "wave_id"
                    ],

                     "household_characteristics": [
                                    "household_characteristics_id",
                                    "household_id",
                                    "wave_id",
                                    "household_characteristics_concept_id",
                                    "household_characteristics_concept_text"
                    ],

                    "individual":[ 
                                   "individual_id",
                                   "individual_id_value",
                                   "household_id",
                                   "gender_concept_id",
                                   "first_wave_id",
                                   "age_at_first_wave",
                                   "year_of_birth",
                                   "is_household_head"
                      
                   ],
                   "individual_demographics": [
                                  "individual_demographics_id",
                                  "individual_id",
                                  "individual_concept_id",
                                  "individual_concept_id_text"
                   ],
                                  
                  "interview":[
                               "interview_id",
                                "individual_id",
                                "interview_date",
                                "wave_id",
                                "instrument_id"
                  ],

                  "longitudinal_population_study_fact": [
                               "fact_id",
                               "individual_id",
                               "interview_id",
                               "resident_episode_id",
                               "population_study_id",
                               "instrument_id",
                               "instrument_item_id",
                               "concept_id",
                               "value_type_concept_id",
                               "value_as_char",
                               "value_as_num",
                               "value_as_concept",
                               "is_indv_level"
                  ]
                  
                    }



