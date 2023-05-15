""" """ # coding: utf-8

import psycopg2
import os
import pandas as pd
import time
#import xlsxwriter


from datetime import datetime

os.chdir(os.path.dirname(os.path.abspath(__file__)))

end_filename = 'base_' + datetime.today().strftime('%Y%m%d%H%M%S') + '.csv'
end_filepath = os.path.join(os.path.dirname(os.path.realpath(__file__)), end_filename)
sql_querypath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'query.sql')

if os.path.isfile(end_filepath):
    pass
else:
    try:
        conn = psycopg2.connect(dbname = 'florianopolis_saude',
                                host = 'dbsaudeflorianopolisleitura.celk.com.br',
                                user = 'alexandre_silva',
                                password = 'Z4yvpw8Dr6djJ5S3')
        conn.set_client_encoding('UTF-8')
        with open(sql_querypath, 'r', encoding='utf-8') as queryfile:
            query = queryfile.read()
        q_df = pd.read_sql_query(query, conn)
        q_df.to_csv(end_filepath, index=False, na_rep='')
        conn.close()
    except:
        print('fudeu')
        #time.sleep(600)
        count = 600
        while count > 0:
            print(count)
            count = count - 1
            time.sleep(1)
        print('tentanto de novo')
        conn = psycopg2.connect(dbname = 'florianopolis_saude',
                                host = 'dbsaudeflorianopolisleitura.celk.com.br',
                                user = 'matheus_andrade',
                                password = 'ma63148F13498')
        conn.set_client_encoding('UTF-8')
        with open(sql_querypath, 'r', encoding='utf-8') as queryfile:
            query = queryfile.read()
        q_df = pd.read_sql_query(query, conn)
        q_df.to_csv(end_filepath, index=False, na_rep='')
        conn.close()

time.sleep(10)

