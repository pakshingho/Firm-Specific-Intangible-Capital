#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May  2 21:33:41 2020

@author: Pak Shing Ho

This script plot tangible to intangible investment and price ratios using data
from BEA.
"""

import pandas as pd
import matplotlib.pyplot as plt
import pandas_datareader.data as web
from datetime import datetime

"""
Plot investment ratio and price ratio
"""
start = '1947-01-01'
end = now = datetime.now().date()

# Gross Private Domestic Investment
inv = web.DataReader('GPDI', 'fred', start=start, end=end)
inv.rename(columns={'GPDI': 'Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products
ip = web.DataReader('Y001RC1Q027SBEA', 'fred', start=start, end=end)
ip.rename(columns={'Y001RC1Q027SBEA': 'I_int'}, inplace=True)

# Gross private domestic investment (implicit price deflator) (A006RD3Q086SBEA)
invdef = web.DataReader('A006RD3Q086SBEA', 'fred', start=start, end=end)
invdef.rename(columns={'A006RD3Q086SBEA': 'P_Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator (Y001RD3Q086SBEA)
ipdef = web.DataReader('Y001RD3Q086SBEA', 'fred', start=start, end=end)
ipdef.rename(columns={'Y001RD3Q086SBEA': 'P_int'}, inplace=True)

# Merge all series into a dataframe
df = pd.merge(inv, ip, left_index=True, right_index=True)
df = pd.merge(df, invdef, left_index=True, right_index=True)
df = pd.merge(df, ipdef, left_index=True, right_index=True)

# Construct tangible investment deflator and nominal tangible investment
df['I_tan'] = df['Inv'] - df['I_int']
df['I_int_real'] = df['I_int'] / df['P_int']
df['Inv_real'] = df['Inv'] / df['P_Inv']

df['P_tan'] = df['P_Inv'] - df['I_int_real'] / (df['Inv_real'] - df['I_int_real']) * (df['P_int'] - df['P_Inv'])

df['I_ratio'] = df['I_int'] / df['I_tan']
df['P_ratio'] = df['P_int'] / df['P_tan']


#plt.style.use('fivethirtyeight')
#plt.style.use('seaborn')
fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel('Date')
ax1.set_ylabel('Intangible to tangible investment ratio', color=color)
ax1.plot(df['I_ratio'], color=color)
#ax1.grid(b=False)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Intangible to tangible price ratio', color=color)  # we already handled the x-label with ax1
ax2.plot(df['P_ratio'], color=color)
#ax2.grid(b=False)
ax2.tick_params(axis='y', labelcolor=color)
ax2.set_ylim(0.9, 1.4)
#fig.tight_layout() # otherwise the right y-label is slightly clipped
plt.show()
