#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 18:21:35 2020

@author: Pak Shing Ho
"""

import pandas as pd

import wrds

ces = pd.read_csv('http://www.nber.org/nberces/nberces5811/sic5811.csv') # sic version
# ces = pd.read_csv('http://www.nber.org/nberces/nberces5811/naics5811.csv') # naics version

#df = pd.read_csv('data/sic5811.csv')
#df2 = pd.read_csv('data/naics5811.csv')
#totalq = pd.read_csv('data/total_q.csv')

conn = wrds.Connection()
conn.describe_table(library="comp", table="names")['name'].to_list()
names = conn.raw_sql("""
                   select *
                   from comp.names
                   """)

# conn.list_libraries()
# conn.list_tables(library="totalq")
# conn.describe_table(library="totalq", table="total_q")

totalq = conn.raw_sql("""
                   select *
                   from totalq.total_q
                   """)
                   
df = pd.merge(totalq, names, on='gvkey')
df.sic = df.sic.astype(int)
df = pd.merge(df, ces, left_on=['sic', 'fyear'], right_on=['sic', 'year'])

df.to_csv('capital.csv', index=False)
