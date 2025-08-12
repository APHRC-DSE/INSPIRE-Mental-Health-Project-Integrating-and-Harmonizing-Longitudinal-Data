import pandas as pd
import numpy as np
import psycopg2
import sqlalchemy as db
import re, os
import logging
if not os.path.isdir('Log'):
    os.mkdir('Log')

logging.basicConfig(
    format='%(asctime)s:%(levelname)s: %(message)s',  
    filemode='w', 
    level=logging.INFO  
)

file_handler = logging.FileHandler('Log/logging.txt', mode='w') 
console_handler = logging.StreamHandler()  

formatter = logging.Formatter('%(asctime)s:%(levelname)s: %(message)s')
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)

# Get the root logger and add both handlers
logger = logging.getLogger()
logger.addHandler(file_handler)
logger.addHandler(console_handler)

class db_connection():

    def __init__(self,database_name="local"):
        
        if database_name == 'prod':
            #report_2_connection
            self.database = 'prod_db'
            self.host = 'prod_ip' 
            self.username = 'prod_user' 
            self.password = 'prod_pass'
            self.port = 5432  
        
        if database_name == 'local':
            self.database = 'postgres'
            self.host = '172.21.0.9' 
            self.username = 'postgres'  
            self.password = 'mypass'
            self.port = 5432    
        self.engine = db.create_engine("postgresql+psycopg2://{0}:{1}@{2}:{3}/{4}".format(self.username,self.password,self.host,self.port,self.database))
            
       
    def get_query(self,schema, table):
        '''
        Returns a pandas DF From an SQL query
        '''
        query ="SELECT * FROM {}.{}".format(schema, table)
        df = pd.read_sql(query,self.engine)
        return df
    
    def upload_df(self,df,table,schema,index=True,index_label='id',if_exists='append'):
        '''
        Appends a DF to a table.
        Uses the index as the id for the table, so make sure the index is the right one. 
        '''
        df.to_sql(self.engine,table,schema,index=index,if_exists=if_exists,index_label=index_label)

        
    def get_last_index(self,schema, table, key):
        '''
        Returns an integer that is the max id of a table.
        '''
        query = "select max({}) as max from {}.{}".format(str(key), str(schema),str(table))
        df = pd.read_sql(query,self.engine)
        max_id = df['max'].iloc[0]
        return max_id
    
    def add_primary_key(self,table,define_id):
        try:
            query = 'alter table {} add primary key ({})'
            query = query.format(table,define_id)
            self.engine.execute(query)
            print ("Primary KEY added to: "+ table)
        except Exception as e:
            print (table+" Table Error: "+e.args[0])
    def get_row_count(self,schema,table):
        '''Returns the number of rows in the table'''
        query = "select COUNT(*) as row_total from {}.{}".format(str(schema), str(table))
        df = pd.read_sql(query,self.engine)
        total_rows = df['row_total'].iloc[0]
        return total_rows
    

postgresql = db_connection()




