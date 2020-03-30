#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 29 20:58:17 2020

@author: shinggg
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.tsa.api import VAR

mdata = pd.read_excel("data/gdp_capital_q.xls")

# prepare the dates index
dates = mdata['Time']
quarterly = dates.str[-4:] + dates.str[:2]
from statsmodels.tsa.base.datetools import dates_from_str
quarterly = dates_from_str(quarterly)
mdata = mdata[['capital', 'gdp']]
mdata.index = pandas.DatetimeIndex(quarterly)

mdata[['logCapital', 'logGDP']] = np.log(mdata).dropna()

mdata[['logCapital', 'logGDP']].plot()

for var in ['logCapital', 'logGDP']:
    cycle, trend = sm.tsa.filters.hpfilter(mdata[var], 1600)
    mdata[cycle.name] = cycle
    mdata[trend.name] = trend
    
mdata[['logCapital', 'logCapital_trend', 'logGDP', 'logGDP_trend']].plot()
mdata[['logCapital_cycle', 'logGDP_cycle']].plot()

data = mdata[['logCapital_cycle', 'logGDP_cycle']]

# make a VAR model
model = VAR(data)
results = model.fit(1)
#results.summary()
#results.plot()
#results.plot_acorr()

#model.select_order(15)
#results = model.fit(maxlags=15, ic='aic')
#results.summary()

#lag_order = results.k_ar
#results.forecast(data.values[-lag_order:], 5)
#results.plot_forecast(10)

irf = results.irf(periods=25)
irf.plot(orth=True)
irf.plot(orth=True, impulse='logGDP_cycle', response='logCapital_cycle')
irf.plot_cum_effects(orth=True)

from pandas_datareader.data import DataReader
# Get the datasets from FRED
start = '1960-01-01'
end = '2020-12-01'
rec = DataReader('USREC', 'fred', start=start, end=end)
reces = rec.resample('Q', convention='start').max()

fig, ax = plt.subplots(figsize=(13,3))
dates = data.index #data.index._mpl_repr()
ax.plot(data)
ylim = ax.get_ylim()
ax.fill_between(dates[:len(reces)], ylim[0], ylim[1], reces.values[:,0], facecolor='k', alpha=0.3)

