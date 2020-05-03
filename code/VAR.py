#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 29 20:58:17 2020

@author: shinggg
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pandas_datareader.data as web
import statsmodels.api as sm
from statsmodels.tsa.api import VAR

mdata = pd.read_excel("../data/gdp_capital_q.xls")

# prepare the dates index
dates = mdata['Time']
quarterly = dates.str[-4:] + dates.str[:2]
from statsmodels.tsa.base.datetools import dates_from_str
quarterly = dates_from_str(quarterly)
mdata = mdata[['capital', 'gdp']]
mdata.index = pd.DatetimeIndex(quarterly)

mdata[['logCapital', 'logGDP']] = np.log(mdata).dropna()

mdata[['logCapital', 'logGDP']].plot()

for var in ['logCapital', 'logGDP']:
    cycle, trend = sm.tsa.filters.hpfilter(mdata[var], 1600)
    mdata[cycle.name] = cycle
    mdata[trend.name] = trend

mdata[['logCapital', 'logCapital_trend', 'logGDP', 'logGDP_trend']].plot()
mdata[['logCapital_cycle', 'logGDP_cycle']].plot()

data = mdata[['logCapital_cycle', 'logGDP_cycle']]
data = data[data.index < '2020-03-31']

# make a VAR model
model = VAR(data)
results = model.fit(4)
#results.summary()
#results.plot()
#results.plot_acorr()

#model.select_order(15)
#results = model.fit(maxlags=15, ic='aic')
#results.summary()

#lag_order = results.k_ar
#results.forecast(data.values[-lag_order:], 5)
#results.plot_forecast(10)

plt.style.use('fivethirtyeight')
plt.style.use('seaborn')
irf = results.irf(periods=25)
irf.plot(orth=True)
irf.plot(orth=True, impulse='logGDP_cycle', response='logCapital_cycle')
#irf.plot_cum_effects(orth=True)

# Get the NBER based Recession Indicators for the United States from the Period following the Peak through the Trough from FRED
start = '1960-04-01'
end = '2021-01-01'
rec = web.DataReader('USREC', 'fred', start=start, end=end)
from pandas.tseries.offsets import Day, MonthEnd
rec.index = rec.index - MonthEnd(1)

plt.style.use('fivethirtyeight')
plt.style.use('seaborn')
fig, ax = plt.subplots(figsize=(13,8))
dates = data.index #data.index._mpl_repr()
ax.plot(data)
ax.legend(data)
ylim = ax.get_ylim()
ax.fill_between(rec[rec.index.isin(dates)].index, ylim[0], ylim[1], rec[rec.index.isin(dates)].values[:,0], facecolor='k', alpha=0.3)


"""
Plot investment ratio and price ratio
"""
from datetime import datetime

start = '1947-01-01'
end = now = datetime.now().date()

# Gross Private Domestic Investment
inv = web.DataReader('GPDI', 'fred', start=start, end=end)
inv.rename(columns={'GPDI': 'I_tan'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products
ip = web.DataReader('Y001RC1Q027SBEA', 'fred', start=start, end=end)
ip.rename(columns={'Y001RC1Q027SBEA': 'I_int'}, inplace=True)

# Gross private domestic investment (implicit price deflator) (A006RD3Q086SBEA)
invdef = web.DataReader('A006RD3Q086SBEA', 'fred', start=start, end=end)
invdef.rename(columns={'A006RD3Q086SBEA': 'P_tan'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator (Y001RD3Q086SBEA)
ipdef = web.DataReader('Y001RD3Q086SBEA', 'fred', start=start, end=end)
ipdef.rename(columns={'Y001RD3Q086SBEA': 'P_int'}, inplace=True)

df = pd.merge(inv, ip, left_index=True, right_index=True)
df = pd.merge(df, invdef, left_index=True, right_index=True)
df = pd.merge(df, ipdef, left_index=True, right_index=True)
df['I_ratio'] = df['I_int'] / df['I_tan']
df['P_ratio'] = df['P_int'] / df['P_tan']


plt.style.use('fivethirtyeight')
plt.style.use('seaborn')
fig, ax1 = plt.subplots()
color = 'tab:red'
ax1.set_xlabel('Date')
ax1.set_ylabel('Intangible to tangible investment ratio', color=color)
ax1.plot(df['I_ratio'], color=color)
ax1.grid(b=False)
ax1.tick_params(axis='y', labelcolor=color)
ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
color = 'tab:blue'
ax2.set_ylabel('Intangible to tangible price ratio', color=color)  # we already handled the x-label with ax1
ax2.plot(df['P_ratio'], color=color)
ax2.grid(b=False)
ax2.tick_params(axis='y', labelcolor=color)
#ax2.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()