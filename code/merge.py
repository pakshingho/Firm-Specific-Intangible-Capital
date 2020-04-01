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

funda = conn.raw_sql("""
                     select gvkey, fyear, at, sale, ppegt
                     from
                     comp.funda
                     where
                     (sale > 0 and at > 0)
                     and consol = 'C'
                     and indfmt = 'INDL'
                     and datafmt = 'STD'
                     and popsrc = 'D'
                     and curcd = 'USD'
                     and final = 'Y'
                     and fic = 'USA'
                     and datadate >= '1949-01-01'
                     """)
conn.close()

df = pd.merge(totalq, names, on='gvkey')
df = pd.merge(df, funda, on=['gvkey', 'fyear'])
df.drop(columns=['q_tot', 'conm', 'tic', 'cusip', 'cik', 'gsubind', 'gind', 'year1', 'year2'], inplace=True)
df = df.groupby(['sic', 'fyear'], as_index=False).sum()

df.sic = df.sic.astype(int)
data = pd.merge(df, ces, left_on=['sic', 'fyear'], right_on=['sic', 'year'])

data.to_csv('../data/capital.csv', index=False)