#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 18:21:35 2020

@author: Pak Shing Ho
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pandas_datareader.data as web
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
                     select gvkey, fyear, at, sale, ppegt, xrd, xsga, capx
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

start = '1949-01-01'
end = '2021-01-01'
# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator (Y001RD3A086NBEA)
intdef = web.DataReader('Y001RD3A086NBEA', 'fred', start=start, end=end)
intdef['fyear'] = intdef.index.year
intdef.rename(columns={"Y001RD3A086NBEA": 'intdef'}, inplace=True)

# Gross private domestic investment: Fixed investment: Nonresidential (implicit price deflator) (A008RD3A086NBEA)
tandef = web.DataReader('A008RD3A086NBEA', 'fred', start=start, end=end)
tandef['fyear'] = intdef.index.year
tandef.rename(columns={"A008RD3A086NBEA": 'tandef'}, inplace=True)

deflator = pd.merge(tandef, intdef)
# make 1987 as base 100
deflator['tandef'] = deflator['tandef'] / deflator.loc[deflator['fyear'] == 1987, 'tandef'].values
deflator['intdef'] = deflator['intdef'] / deflator.loc[deflator['fyear'] == 1987, 'intdef'].values

# construct firm level intangible investment
# funda['invest_int'] = funda['xrd'] + 0.3 * funda['xsga']

df = pd.merge(totalq, names, on='gvkey')
df = pd.merge(df, funda, on=['gvkey', 'fyear'])
df.drop(columns=['q_tot', 'conm', 'tic', 'cusip', 'cik', 'gsubind', 'gind', 'year1', 'year2'], inplace=True)
df = df.groupby(['sic', 'fyear'], as_index=False).sum()

df.sic = df.sic.astype(int)
data = pd.merge(df, ces, left_on=['sic', 'fyear'], right_on=['sic', 'year'])

data = pd.merge(data, deflator, on='fyear')

# Construct sic level intangible investment
data['inv_int'] = data['xrd'] + 0.3 * data['xsga']

data.to_csv('FirmSpecificIntangibleCapital/data/capital.csv', index=False)


data = pd.read_csv('FirmSpecificIntangibleCapital/data/capital.csv')

data = data[data['fyear'] > 1975]

data['share1'] = data['k_int'] / (data['k_int'] + data['ppegt'])
data['share2'] = data['k_int'] / data['at']

# plot an example SIC industry share
data['fyear'] = pd.to_datetime(data['fyear'], format='%Y').dt.year
plt.plot(data[(data.sic == 2011)]['fyear'], data[(data.sic == 2011)][['share1', 'share2']])
plt.legend(['Share of total capitals', 'Share of total assets'])
plt.title('SIC: 2011')
plt.show()

data2 = data.groupby('sic', as_index=False).mean()
data2 = data2[['sic', 'share1', 'share2']]

# bins by share1
data2.sort_values('share1', inplace=True)
data2.reset_index(drop=True, inplace=True)

# Visualize relationship between share measures
plt.scatter(data2.share1, data2.share2, marker='x')
plt.scatter(range(len(data2.share1)), data2.share1, marker='.', alpha=0.8)
plt.scatter(range(len(data2.share2)), data2.share2, marker='x', alpha=0.8)
plt.show()

# bins by share1
L_s1 = data2.loc[0:np.floor(len(data2)/3), ['sic', 'share1']]
M_s1 = data2.loc[np.ceil(len(data2)/3): np.floor(len(data2)*2/3), ['sic', 'share1']]
H_s1 = data2.loc[np.ceil(len(data2)*2/3):len(data2), ['sic', 'share1']]

# bins by share2
data2.sort_values('share2', inplace=True)
data2.reset_index(drop=True, inplace=True)
L_s2 = data2.loc[0:np.floor(len(data2)/3), ['sic', 'share2']]
M_s2 = data2.loc[np.ceil(len(data2)/3): np.floor(len(data2)*2/3), ['sic', 'share2']]
H_s2 = data2.loc[np.ceil(len(data2)*2/3):len(data2), ['sic', 'share2']]

# collect data after sorting in bins
data_L_s1 = data[data['sic'].isin(L_s1['sic'])]
data_M_s1 = data[data['sic'].isin(M_s1['sic'])]
data_H_s1 = data[data['sic'].isin(H_s1['sic'])]

data['share_type'] = ''
data.loc[data['sic'].isin(L_s1['sic']), 'share1_type'] = 'L'
data.loc[data['sic'].isin(M_s1['sic']), 'share1_type'] = 'M'
data.loc[data['sic'].isin(H_s1['sic']), 'share1_type'] = 'H'

data_L_s2 = data[data['sic'].isin(L_s2['sic'])]
data_M_s2 = data[data['sic'].isin(M_s2['sic'])]
data_H_s2 = data[data['sic'].isin(H_s2['sic'])]

data.loc[data['sic'].isin(L_s2['sic']), 'share2_type'] = 'L'
data.loc[data['sic'].isin(M_s2['sic']), 'share2_type'] = 'M'
data.loc[data['sic'].isin(H_s2['sic']), 'share2_type'] = 'H'

# save sorted data
data_L_s1.to_csv('FirmSpecificIntangibleCapital/data/data_L_s1.csv', index=False)
data_M_s1.to_csv('FirmSpecificIntangibleCapital/data/data_M_s1.csv', index=False)
data_H_s1.to_csv('FirmSpecificIntangibleCapital/data/data_H_s1.csv', index=False)
data_L_s2.to_csv('FirmSpecificIntangibleCapital/data/data_L_s2.csv', index=False)
data_M_s2.to_csv('FirmSpecificIntangibleCapital/data/data_M_s2.csv', index=False)
data_H_s2.to_csv('FirmSpecificIntangibleCapital/data/data_H_s2.csv', index=False)
data.to_csv('FirmSpecificIntangibleCapital/data/capital.csv', index=False)