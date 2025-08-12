staging_tables = { "concept":[
                            "concept_vocabulary",
                            "concept_code",
                            "concept_text",
                            "start_date",
                            "end_date",
                            "inspire_concept_id",
                            "concept_id",
                             "score"
                 ],
                  
                    "data_capture_event":[
                             "data_capture_id",
                             "wave_id",
                             "instrument_id",
                             "completion_status",
                             "data_quality_indicator",
                             "mode_of_collection_description",
                             "mode_of_collection_type",
                             "data_capture_collector",
                             "data_source_description",
                             "data_source_type",
                             "data_capture_event_date"
                  ],
    
                  "household":[
                                    "household_id",
                                    "household_id_value",
                                    "location_id",
                                    "household_head_id"                    

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
                  
                  "instrument":[
                                 "instrument_id",
                                 "name",
                                 "description",
                                 "instrument_type_concept_id",
                                 "version",
                                 "version_date",
                                 "language_concept_id"
                  ],
                  
                  "instrument_item":[ 
                                 "instrument_item_id",
                                 "instrument_id",
                                 "name",
                                 "description",
                                 "instrument_item_type_concept_id",
                                 "instrument_item_concept_vocabulary",
                                 "instrument_item_concept_vocabulary_id",
                                 "alternative_instrument_item_concept_vocabulary",
                                 "alternative_instrument_item_concept_vocabulary_id",
                                 "result_not_null_answer_list_concept_vocabulary"
                  ],
                  
                  "interview":[
                               "interview_id",
                                "individual_id",
                                "interview_date",
                                "wave_id",
                                "instrument_id"
                  ],
                   
                  "location":[
                                "location_id",
                                "village_name",
                                "place_kind",
                                "latitude",
                                "longitude"
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
                  ],
                  "methodology":[
                               "methodology_id",
                               "data_collection_methodology_description",
                               "data_collection_methodology_type",
                               "time_method_description",
                               "time_method_type",
                               "sampling_procedure_description",
                               "sampling_procedure_type",
                               "data_collection_software_name",
                               "data_collection_software_version",
                               "data_collection_software_package_type",
                               "quality_statement_standard_name",
                               "quality_statement_standard_description",
                               "population_study_id"
                  ],
                  
                  "population_study":[
                               "name",
                               "description",
                               "country",
                               "abstract",
                               "phenotype_description",
                               "outcome_phenotype_description",
                               "covariates_description",
                               "analyses_supported_text",
                               "version",
                               "version_date",
                               "citation_creators",
                               "citation_contributors",
                               "universe_spatial_coverage_text",
                               "population_study_id",
                               "doi_registry",  
                               "doi_value",
                               "url",
                               "citation_title",
                               "citation_publisher",
                               "citation_language_concept_id",
                               "keywords",
                               "universe_spatial_coverage_concept_id",
                               "universe_temporal_coverage",
                               "analyses_supported_concept_id"
                      
                  ],
                  "wave":[ 
                              "wave_id",
                              "name",
                              "description",
                              "instrument_model_type_concept_id",
                              "start_date",
                              "end_date",
                              "kind_of_data_concept_id",
                              "authorizing_agency_concept_id",
                              "authorizing_statement",
                              "population_study_id"
                  ],
                  
    
                "resident_episode":[
                                    "resident_episode_id",
                                    "location_id",
                                    "household_id",
                                    "wave_id"
                ]
    
    
                    }



