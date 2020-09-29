#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 28 15:43:14 2020

@author: Pak Shing Ho
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# import pandas_datareader.data as web
from datetime import datetime
import statsmodels.api as sm
from statsmodels.tsa.api import VAR

Intangible = pd.read_excel('data/IndustryInt.xls',
                           sheet_name='Sheet0',
                           index_col='Date')
Intangible.rename(columns={'Management of companies and enterprises 5':'Management of companies and enterprises'}, inplace=True)

Tangible = pd.read_excel('data/IndustryTan.xls',
                           sheet_name='Sheet0',
                           index_col='Date')
Tangible.rename(columns={'Management of companies and enterprises 5':'Management of companies and enterprises'}, inplace=True)

# Tangible.columns == Intangible.columns

VADD = pd.read_excel('data/IndustryVADD.xls',
                           sheet_name='VADD',
                           index_col='Date')

Output = pd.read_excel('data/IndustryY.xls',
                           sheet_name='Output',
                           index_col='Date')

# VADD.columns == Output.columns

# print out columns
# for i in Intangible.columns:
#     print("'" + i + "'"+",")
    
ind_list = ['Private fixed assets',
'Agriculture, forestry, fishing, and hunting',
'Mining',
'Utilities',
'Construction',
'Manufacturing',
'Durable goods',
'Wood products',
'Nonmetallic mineral products',
'Primary metals',
'Fabricated metal products',
'Machinery',
'Computer and electronic products',
'Electrical equipment, appliances, and components',
'Motor vehicles, bodies and trailers, and parts',
'Other transportation equipment',
'Furniture and related products',
'Miscellaneous manufacturing',
'Nondurable goods',
'Food and beverage and tobacco products',
'Textile mills and textile product mills',
'Apparel and leather and allied products',
'Paper products',
'Printing and related support activities',
'Petroleum and coal products',
'Chemical products',
'Plastics and rubber products',
'Wholesale trade',
'Retail trade',
'Transportation and warehousing',
'Information',
'Finance and insurance',
'Real estate and rental and leasing',
'Professional, scientific, and technical services',
'Management of companies and enterprises',
'Administrative and waste management services',
'Educational services',
'Health and social assistance',
'Arts, entertainment, and recreation',
'Accommodation and food services',
'Other services, except government']

# for i in VADD.columns:
#     print("'" + i + "'"+",")
    
ind_list2 = ['Gross domestic product',
'Private industries',
'Agriculture, forestry, fishing, and hunting',
'Mining',
'Utilities',
'Construction',
'Manufacturing',
'Durable goods',
'Wood products',
'Nonmetallic mineral products',
'Primary metals',
'Fabricated metal products',
'Machinery',
'Computer and electronic products',
'Electrical equipment, appliances, and components',
'Motor vehicles, bodies and trailers, and parts',
'Other transportation equipment',
'Furniture and related products',
'Miscellaneous manufacturing',
'Nondurable goods',
'Food and beverage and tobacco products',
'Textile mills and textile product mills',
'Apparel and leather and allied products',
'Paper products',
'Printing and related support activities',
'Petroleum and coal products',
'Chemical products',
'Plastics and rubber products',
'Wholesale trade',
'Retail trade',
'Transportation and warehousing',
'Information',
'Finance, insurance, real estate, rental, and leasing',
'Finance and insurance',
'Real estate and rental and leasing',
'Professional and business services',
'Professional, scientific, and technical services',
'Management of companies and enterprises',
'Administrative and waste management services',
'Educational services, health care, and social assistance',
'Educational services',
'Health care and social assistance',
'Arts, entertainment, recreation, accommodation, and food services',
'Arts, entertainment, and recreation',
'Accommodation and food services',
'Other services, except government',
'Government',
'Federal',
'State and local']

#len(list(set(ind_list) & set(ind_list2)))
intersect_list = list(set(ind_list) & set(ind_list2))

Intangible = Intangible[intersect_list]
Tangible = Tangible[intersect_list]
VADD = VADD[intersect_list]
Output = Output[intersect_list]

# --- Consutrct log-differenced real variables
df = pd.DataFrame()
df['Output'] = np.log(VADD['Manufacturing']).diff()
df['Tangible'] = np.log(Tangible['Manufacturing']).diff()
df['Intangible'] = np.log(Intangible['Manufacturing']).diff()

"""
Estimate 3-VAR using 400*log-differenced series
"""
#data = df[['Output', 'Intangible', 'Tangible']]
data = df[['Tangible', 'Intangible', 'Output']]
#data = df[['Intangible', 'Tangible', 'Output']]
data = data[(data.index >= 1948) & (data.index <= 2019)]
model = VAR(data)
result = model.fit(maxlags=8, ic=None, verbose=True)
result.summary()

irf = result.irf(periods=8)
#irf.plot(orth=True, impulse='Output')
irf.plot_cum_effects(orth=False, impulse='Output', response='Output')

pd.Series(irf.cum_effects[0:21,2,2]).plot()
pd.Series(irf.cum_effects[0:21,2,2])

"""
Loop industries
"""
irf_dict = {}
result_dict = {}
for i in intersect_list:
    print(i)
    df = pd.DataFrame()
    df['Output'] = np.log(VADD[i]).diff()
    df['Tangible'] = np.log(Tangible[i]).diff()
    df['Intangible'] = np.log(Intangible[i]).diff()
    
    """
    Estimate 3-VAR log-differenced series
    """
    #data = df[['Output', 'Intangible', 'Tangible']]
    data = df[['Tangible', 'Intangible', 'Output']]
    #data = df[['Intangible', 'Tangible', 'Output']]
    data = data[(data.index >= 1962) & (data.index <= 2019)]
    model = VAR(data)
    result = model.fit(maxlags=8, ic=None, verbose=True)
    # result.summary()
    result_dict[i] = result
    
    irf = result.irf(periods=10)
    #irf.plot(orth=True, impulse='Output')
    #irf.plot_cum_effects(orth=False, impulse='Output', response='Output')
    
    # pd.Series(irf.cum_effects[0:15,2,2]).plot()
    #pd.Series(irf.cum_effects[0:15,2,2])
    irf_dict[i] = pd.Series(irf.cum_effects[0:15,2,2])
    
for i in irf_dict:
    irf_dict[i].plot()


"""
loop humped industries
"""
hump_list=['Accommodation and food services', #small
           'Construction', #huge
           'Nonmetallic mineral products', #tiny
           'Manufacturing', #big
           'Wood products', # delayed small
           'Durable goods', #big
           'Arts, entertainment, and recreation', # small delayed
           'Management of companies and enterprises', # small
           'Petroleum and coal products', #small delayed
           'Nondurable goods', #small delayed
           'Furniture and related products', #big
           'Educational services' #big persistent
           ]

hump_order_list= (Intangible.loc[1962, hump_list]/ (Intangible.loc[1962, hump_list] + Tangible.loc[1962,hump_list])).sort_values().index

irf_dict = {}
result_dict = {}
for i in hump_order_list:
    print(i)
    df = pd.DataFrame()
    df['Output'] = np.log(VADD[i]).diff()
    df['Tangible'] = np.log(Tangible[i]).diff()
    df['Intangible'] = np.log(Intangible[i]).diff()
    
    """
    Estimate 3-VAR log-differenced series
    """
    #data = df[['Output', 'Intangible', 'Tangible']]
    data = df[['Tangible', 'Intangible', 'Output']]
    #data = df[['Intangible', 'Tangible', 'Output']]
    data = data[(data.index >= 1962) & (data.index <= 2019)]
    model = VAR(data)
    result = model.fit(maxlags=8, ic=None, verbose=True)
    # result.summary()
    result_dict[i] = result
    
    irf = result.irf(periods=10)
    #irf.plot(orth=True, impulse='Output')
    #irf.plot_cum_effects(orth=False, impulse='Output', response='Output')
    
    # pd.Series(irf.cum_effects[0:15,2,2]).plot()
    #pd.Series(irf.cum_effects[0:15,2,2])
    irf_dict[i] = pd.Series(irf.cum_effects[0:15,2,2])
    
plt.style.use('ggplot')
for i in irf_dict:
    irf_dict[i].plot()
plt.legend(hump_order_list, ncol=1, bbox_to_anchor=(1, 1))
plt.title('Cumulative responses of output shock to output')

irf_dict['Accommodation and food services'].plot()
irf_dict['Construction'].plot()
irf_dict['Furniture and related products'].plot()
plt.legend(['Accommodation and food services', 'Construction', 'Furniture and related products'])
plt.title('Cumulative responses of output shock to output')

irf_dict['Wood products'].plot()
irf_dict['Petroleum and coal products'].plot()
irf_dict['Arts, entertainment, and recreation'].plot()
plt.legend(['Wood products', 'Petroleum and coal products', 'Arts, entertainment, and recreation'])
plt.title('Cumulative responses of output shock to output')

(1/3*(irf_dict['Wood products']+irf_dict['Petroleum and coal products']+irf_dict['Arts, entertainment, and recreation'])).plot()
(1/3*(irf_dict['Accommodation and food services']+irf_dict['Construction']+irf_dict['Furniture and related products'])).plot()
plt.legend(['High Intangible Share', 'Low Intangible Share'])
plt.title('Cumulative responses of output shock to output')

(Intangible.loc[1962, hump_list]/ (Intangible.loc[1962, hump_list] + Tangible.loc[1962,hump_list])).sort_values()

(Intangible.loc[1962, intersect_list]/ (Intangible.loc[1962, intersect_list] + Tangible.loc[1962,intersect_list])).sort_values()

# shares ordered by intersect_list
intersect_order_list = (Intangible.loc[1962, intersect_list]/ (Intangible.loc[1962, intersect_list] + Tangible.loc[1962,intersect_list])).sort_values().index

"""
Loop industries and aggregate CIRF
"""
irf_dict = {}
result_dict = {}
for i in intersect_order_list:
    print(i)
    df = pd.DataFrame()
    df['Output'] = np.log(VADD[i]).diff()
    df['Tangible'] = np.log(Tangible[i]).diff()
    df['Intangible'] = np.log(Intangible[i]).diff()
    
    """
    Estimate 3-VAR log-differenced series
    """
    #data = df[['Output', 'Intangible', 'Tangible']]
    data = df[['Tangible', 'Intangible', 'Output']]
    #data = df[['Intangible', 'Tangible', 'Output']]
    data = data[(data.index >= 1962) & (data.index <= 2019)]
    model = VAR(data)
    result = model.fit(maxlags=8, ic=None, verbose=True)
    # result.summary()
    result_dict[i] = result
    
    irf = result.irf(periods=10)
    #irf.plot(orth=True, impulse='Output')
    #irf.plot_cum_effects(orth=False, impulse='Output', response='Output')
    
    # pd.Series(irf.cum_effects[0:15,2,2]).plot()
    #pd.Series(irf.cum_effects[0:15,2,2])
    irf_dict[i] = pd.Series(irf.cum_effects[0:15,2,2])

agg_cirf = np.zeros(11)
for i in irf_dict:
    agg_cirf += irf_dict[i]

(agg_cirf/len(irf_dict)).plot()

"""
aggregate industries and CIRF
"""
df = pd.DataFrame()
df['Output'] = np.log(VADD.mean(axis=1)).diff()
df['Tangible'] = np.log(Tangible.mean(axis=1)).diff()
df['Intangible'] = np.log(Intangible.mean(axis=1)).diff()

"""
Estimate 3-VAR log-differenced series
"""
#data = df[['Output', 'Intangible', 'Tangible']]
data = df[['Tangible', 'Intangible', 'Output']]
#data = df[['Intangible', 'Tangible', 'Output']]
data = data[(data.index >= 1962) & (data.index <= 2019)]
model = VAR(data)
result = model.fit(maxlags=8, ic=None, verbose=True)
# result.summary()

irf = result.irf(periods=10)
#irf.plot(orth=True, impulse='Output')
irf.plot_cum_effects(orth=False, impulse='Output', response='Output')

"""
Low
"""
df = pd.DataFrame()
df['Output'] = np.log(VADD[intersect_order_list[0:20]].mean(axis=1)).diff()
df['Tangible'] = np.log(Tangible[intersect_order_list[0:20]].mean(axis=1)).diff()
df['Intangible'] = np.log(Intangible[intersect_order_list[0:20]].mean(axis=1)).diff()

"""
Estimate 3-VAR log-differenced series
"""
#data = df[['Output', 'Intangible', 'Tangible']]
data = df[['Tangible', 'Intangible', 'Output']]
#data = df[['Intangible', 'Tangible', 'Output']]
data = data[(data.index >= 1962) & (data.index <= 2019)]
model = VAR(data)
result = model.fit(maxlags=4, ic=None, verbose=True)
# result.summary()

irf = result.irf(periods=10)
#irf.plot(orth=True, impulse='Output')
irf.plot_cum_effects(orth=False, impulse='Output', response='Output')

"""
High
"""
df = pd.DataFrame()
df['Output'] = np.log(VADD[intersect_order_list[20:40]].mean(axis=1)).diff()
df['Tangible'] = np.log(Tangible[intersect_order_list[20:40]].mean(axis=1)).diff()
df['Intangible'] = np.log(Intangible[intersect_order_list[20:40]].mean(axis=1)).diff()

"""
Estimate 3-VAR log-differenced series
"""
#data = df[['Output', 'Intangible', 'Tangible']]
data = df[['Tangible', 'Intangible', 'Output']]
#data = df[['Intangible', 'Tangible', 'Output']]
data = data[(data.index >= 1962) & (data.index <= 2019)]
model = VAR(data)
result = model.fit(maxlags=4, ic=None, verbose=True)
# result.summary()

irf = result.irf(periods=10)
#irf.plot(orth=True, impulse='Output')
irf.plot_cum_effects(orth=False, impulse='Output', response='Output')