#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 13 22:27:02 2020

@author: shinggg
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pandas_datareader.data as web
from datetime import datetime
import statsmodels.api as sm
from statsmodels.tsa.api import VAR

# Decide time period
start = '1947-01-01'
end = now = datetime.now().date()

"""
Download data series from FRED
"""
# GDP
gdp = web.DataReader('GDP', 'fred', start=start, end=end)
gdp.rename(columns={'GDP': 'gdp'}, inplace=True)

# Gross Private Domestic Investment
inv = web.DataReader('GPDI', 'fred', start=start, end=end)
inv.rename(columns={'GPDI': 'Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products
ip = web.DataReader('Y001RC1Q027SBEA', 'fred', start=start, end=end)
ip.rename(columns={'Y001RC1Q027SBEA': 'I_int'}, inplace=True)

# GDP Deflator
gdpdef = web.DataReader('GDPDEF', 'fred', start=start, end=end)
gdpdef.rename(columns={'GDPDEF': 'gdpdef'}, inplace=True)

# Gross private domestic investment (implicit price deflator) (A006RD3Q086SBEA)
invdef = web.DataReader('A006RD3Q086SBEA', 'fred', start=start, end=end)
invdef.rename(columns={'A006RD3Q086SBEA': 'P_Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator (Y001RD3Q086SBEA)
ipdef = web.DataReader('Y001RD3Q086SBEA', 'fred', start=start, end=end)
ipdef.rename(columns={'Y001RD3Q086SBEA': 'P_int'}, inplace=True)


"""
Clean and transform data series
"""
# Merge all series into a dataframe
df = pd.merge(inv, ip, left_index=True, right_index=True)
df = pd.merge(df, gdp, left_index=True, right_index=True)
df = pd.merge(df, invdef, left_index=True, right_index=True)
df = pd.merge(df, ipdef, left_index=True, right_index=True)
df = pd.merge(df, gdpdef, left_index=True, right_index=True)

# Construct tangible investment deflator and nominal tangible investment:
# Nominal tangible investment
df['I_tan'] = df['Inv'] - df['I_int']

# Real intangible investment
df['I_int_real'] = df['I_int'] / df['P_int']

# Real total investment
df['Inv_real'] = df['Inv'] / df['P_Inv']

# Tangible investment deflator
df['P_tan'] = df['P_Inv'] - df['I_int_real'] / (df['Inv_real'] - df['I_int_real']) * (df['P_int'] - df['P_Inv'])

# Construct real variables:
# Real tangible investment
df['I_tan_real'] = df['I_tan'] / df['P_tan']

# Real output
df['Output_real'] = df['gdp'] / df['gdpdef']
