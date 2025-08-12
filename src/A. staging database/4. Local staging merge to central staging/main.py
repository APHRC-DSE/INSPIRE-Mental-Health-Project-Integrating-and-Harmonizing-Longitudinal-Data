from library import *
from schema.schema import staging_tables
from schema.custom_schema import new_wave_constant_tables
from pathlib import Path
BASE_DIR = Path(__file__).parent.resolve()
data_path = BASE_DIR / "Data" / "final_datasets"
data_path.mkdir(parents=True, exist_ok=True)
path_to_raw_files = BASE_DIR / "Data"
path_to_processed_files = BASE_DIR / "Data" / "final_datasets"

WAVE = 1

schemas = {"local":"mh_staging_13", "central":"mh_staging_1_1_dev"}

logger.info("Staging migration from local : {} to Central : {}".format(schemas["local"], schemas["central"]))

def generate_new_primary_ids(local_schema, central_schema, local_table, central_table, central_table_column,local_table_new_column):
    '''A function to dynamically generate local table with updated ID column in accordance with central staging database'''
    local_table_view = postgresql.get_query("{}".format(local_schema),"{}".format(local_table)) 
    central_table_last_index= postgresql.get_last_index("{}".format(central_schema), "{}".format(central_table), "{}".format(central_table_column)) 
    local_table_size = postgresql.get_row_count("{}".format(local_schema), "{}".format(local_table))
    local_table_view['id'] = pd.Series([i+central_table_last_index+1 for i in range(local_table_size)])
    local_table_view.rename(columns={"id":"{}".format(local_table_new_column)}, inplace=True)
    return local_table_view



def generate_table_list_with_provided_FK(a_table, a_pk, schema):
    '''Given a primary key and schema this will generate tables with that primary key as a foreign key'''
    logger.info("----------Ready to check tables referencing table : -------------- : {} ".format(a_table))
    tables_referred = {}
    tables = []
    tables.append(a_table)
    for key in schema.keys():  
        if key != a_table:
            if a_pk in schema[key]:
                tables.append(key)

    tables_referred[a_pk] = tables 
    return tables_referred


def generate_table_meta(a_dict_linked_tables):
    '''Generate the key column, table to refer, and linked tables to update...'''
    table_metadata = []
    for key in a_dict_linked_tables.keys():
        if len(a_dict_linked_tables[key]) > 1:
            tables_to_update = a_dict_linked_tables[key][1:]
            table_to_refer = a_dict_linked_tables[key][0]
            key_column = key
            logger.info("Tables to update : {} referring from : {}".format(tables_to_update, table_to_refer))
            logger.info(key+" of {} table is linked in {} table(s) - {}".format(a_dict_linked_tables[key][0], len(a_dict_linked_tables[key])-1, a_dict_linked_tables[key][1:] ))
            table_metadata.extend([key_column,table_to_refer,tables_to_update])
        else:
            logger.info("{} not linked with other tables - Not a FK".format(key))
            table_metadata.extend([key,a_dict_linked_tables[key][0],a_dict_linked_tables[key][1:]])
    return table_metadata
       


def update_fk_with_pk(table_meta, pk):
    ''' Update the foreign keys with the new assigned primary keys'''
    if len(table_meta[2]) > 0:
        pk_new = pk+'_new'
        table_A_path = "Data/{}.csv".format(table_meta[1])
        logger.info(table_A_path)
        table_A = pd.read_csv(table_A_path)
        logger.info(table_A.head())
        columns_to_compare = []
        for id, row in table_A.iterrows():
            columns_to_compare.append([row[pk],row[pk_new]])
        logger.info(columns_to_compare[1:5])

        def update_fk(row):
            '''A function to be called within df.apply segment to rowise update the foreign key based on matching pk'''
            for m in columns_to_compare:
                if m[0] == row:
                    row = m[1]
                    return row

        for fk_tables in table_meta[2]:
            logger.info(fk_tables)
            table_B_path = "Data/{}.csv".format(fk_tables)
            table_B = pd.read_csv(table_B_path)
            logger.info(table_B.head())
            table_B[pk_new] = np.nan
            table_B[pk_new] = table_B[pk].apply(update_fk)
            logger.info(table_B.head())
            table_B.to_csv('{}/{}.csv'.format(path_to_raw_files, fk_tables), index=False)

def write_csv_staging_db(schema):
    '''A function to write the csv to the final staging database'''
    for key in schema:
        try:
            id = schema[key][0]
            df = pd.read_csv('{}/{}.csv'.format(path_to_processed_files,key))
            df.to_sql(key, postgresql.engine, schema=schemas["central"], if_exists='append', index=False)
            logger.info("Local : {} updated successfully on the Central staging database".format(key))
        except:
            logger.info("Local : {}  not updated on the Central staging database".format(key))


def align_table_columns(schema, path):
    '''A function that renames, drops columns of adf based on the schema structure provided'''
    for key in schema:
        df_with_columns = pd.read_csv("Data/{}.csv".format(key))
        schema_columns = schema[key]
        df_columns = df_with_columns.columns
        new_columns = list(set(df_columns)-set(schema_columns))
        logger.info(new_columns)        
        for column in new_columns:
            pattern = r"(.+)_new$"
            col_to_drop = re.search(pattern,column).group(1)
            logger.info("Dropping the initial colum(s) : {}".format(col_to_drop))
            df_with_columns.drop(col_to_drop, axis=1, inplace=True)
            df_with_columns = df_with_columns.rename(columns={column:col_to_drop})
        df_with_columns=df_with_columns[schema_columns]
        df_with_columns.to_csv('{}/{}.csv'.format(path, key), index=False)


def update_new_columns(schema, path):
    '''A function that drops incrementing column created using table last index and re-using initial index suffix'''
    for key in schema:
        df_with_columns = pd.read_csv("Data/{}.csv".format(key))
        schema_columns = schema[key]
        df_columns = df_with_columns.columns
        new_columns = list(set(df_columns)-set(schema_columns))
        logger.info(new_columns)  
        df_with_columns[new_columns[0]] = df_with_columns[schema[key][0]]
        df_with_columns.to_csv('{}/{}.csv'.format(path, key), index=False)    


for key in staging_tables.keys():
    logger.info(key)
    df_gen_ids = generate_new_primary_ids(schemas["local"], schemas["central"],
                                       key,
                                       key,
                                       staging_tables[key][0],
                                       staging_tables[key][0]+"_new"                                       
                                       )
    logger.info(df_gen_ids)
    df_gen_ids.to_csv('{}/{}.csv'.format(path_to_raw_files,key), index=False)

if WAVE > 1:
    '''ONLY run for subsequent waves, Drop newly created IDs since some tables were not updated hence on higher waves, no need to assign new primary IDs'''
    update_new_columns(new_wave_constant_tables, path_to_raw_files)
    

for key in staging_tables.keys():
    a_dict_linked_tables=generate_table_list_with_provided_FK(key,staging_tables[key][0],staging_tables)
    table_meta = generate_table_meta(a_dict_linked_tables)
    logger.info(table_meta)
    logger.info("###--------------------------------------------------------------------###")
    merged_df = update_fk_with_pk(table_meta,table_meta[0])


align_table_columns(staging_tables,path_to_processed_files)
#write_csv_staging_db(staging_tables)
