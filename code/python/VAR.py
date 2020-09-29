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

# Solow residual from https://research.stlouisfed.org/pdl/1034
# tfp = pd.read_csv('Solow_residual_Quarterly.txt',sep='\t')
# tfp.rename(columns={'observation_date': 'DATE', 'GDPC1_20180915': 'TFP'}, inplace=True)
# tfp.set_index('DATE', inplace=True)

# TFP obtained from https://www.frbsf.org/economic-research/indicators-data/total-factor-productivity-tfp/
# It's already in the form of 400*log-differenced!!!
tfp = pd.read_excel('data/tfp.xlsx')
tfp.dropna(inplace=True)
tfp.set_index('DATE', inplace=True)

# annual TFP growth
tfp = pd.read_excel('tfpa.xlsx')
tfp.dropna(inplace=True)
tfp.DATE = pd.to_datetime(tfp.DATE, format='%Y')
tfp.set_index('DATE', inplace=True)

# Decide time period
start = '1947-01-01'
end = now = datetime.now().date()

"""
Download data series from FRED
"""
# --- Quarterly series 
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

# Business Sector: Hours of All Persons (HOABS)
hours = web.DataReader('HOABS', 'fred', start=start, end=end)
hours.rename(columns={'HOABS': 'hours'}, inplace=True)

# Nonfarm Business Sector: Compensation Per Hour (COMPNFB)
realWage = web.DataReader('COMPNFB', 'fred', start=start, end=end)
realWage.rename(columns={'COMPNFB': 'realWage'}, inplace=True)

# Real Personal Consumption Expenditures (PCECC96)
realCons = web.DataReader('PCECC96', 'fred', start=start, end=end)
realCons.rename(columns={'PCECC96': 'realCons'}, inplace=True)

# Effective Federal Funds Rate (FF)
FF = web.DataReader('FF', 'fred', start=start, end=end)
FF.rename(columns={'FF': 'FF'}, inplace=True)
FF = FF.resample('Q', convention='start', loffset='d').mean()

# Corporate Profits After Tax (without IVA and CCAdj) (CP)
CP = web.DataReader('CP', 'fred', start=start, end=end)
CP.rename(columns={'CP': 'CP'}, inplace=True)

# M2 Money Stock (M2SL)
M2 = web.DataReader('M2SL', 'fred', start=start, end=end)
M2.rename(columns={'M2SL': 'M2'}, inplace=True)
M2 = M2.resample('Q', convention='start', loffset='d').mean()

"""
"""
# --- Yearly series
# GDPA
gdp = web.DataReader('GDPA', 'fred', start=start, end=end)
gdp.rename(columns={'GDPA': 'gdp'}, inplace=True)

# Gross Private Domestic Investment
inv = web.DataReader('GPDIA', 'fred', start=start, end=end)
inv.rename(columns={'GPDIA': 'Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products
ip = web.DataReader('Y001RC1A027NBEA', 'fred', start=start, end=end)
ip.rename(columns={'Y001RC1A027NBEA': 'I_int'}, inplace=True)

# Gross Domestic Product: Implicit Price Deflator
gdpdef = web.DataReader('A191RD3A086NBEA', 'fred', start=start, end=end)
gdpdef.rename(columns={'A191RD3A086NBEA': 'gdpdef'}, inplace=True)

# Gross private domestic investment (implicit price deflator)
invdef = web.DataReader('A006RD3A086NBEA', 'fred', start=start, end=end)
invdef.rename(columns={'A006RD3A086NBEA': 'P_Inv'}, inplace=True)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator
ipdef = web.DataReader('Y001RD3A086NBEA', 'fred', start=start, end=end)
ipdef.rename(columns={'Y001RD3A086NBEA': 'P_int'}, inplace=True)

"""
Clean and transform data series
"""
# Merge all series into a dataframe
df = pd.merge(inv, ip, left_index=True, right_index=True)
df = pd.merge(df, gdp, left_index=True, right_index=True)
df = pd.merge(df, invdef, left_index=True, right_index=True)
df = pd.merge(df, ipdef, left_index=True, right_index=True)
df = pd.merge(df, gdpdef, left_index=True, right_index=True)
df = pd.merge(df, hours, left_index=True, right_index=True)
df = pd.merge(df, realWage, left_index=True, right_index=True)
df = pd.merge(df, realCons, left_index=True, right_index=True)
df = pd.merge(df, FF, left_index=True, right_index=True)
df = pd.merge(df, CP, left_index=True, right_index=True)
df = pd.merge(df, M2, left_index=True, right_index=True)
df = pd.merge(df, tfp, left_index=True, right_index=True)

# --- Construct tangible investment deflator and nominal tangible investment:
# Nominal tangible investment
df['I_tan'] = df['Inv'] - df['I_int']

# Real intangible investment
df['I_int_real'] = df['I_int'] / df['P_int']

# Real total investment
df['Inv_real'] = df['Inv'] / df['P_Inv']

# Tangible investment deflator
df['P_tan'] = df['P_Inv'] - df['I_int_real'] / (df['Inv_real'] - df['I_int_real']) * (df['P_int'] - df['P_Inv'])

# --- Construct real variables:
# Real tangible investment
df['I_tan_real'] = df['I_tan'] / df['P_tan']

# Real output
df['Output_real'] = df['gdp'] / df['gdpdef']

# Real profit
df['Profit_real'] = df['CP'] / df['gdpdef']

# Labor productivity
df['Prod'] = df['Output_real'] / df['hours']

# --- Consutrct log real variables
df['logOutput'] = np.log(df['Output_real'])
df['logCons'] = np.log(df['realCons'])
df['logPrice'] = np.log(df['gdpdef']).diff()
df['logI_tan'] = np.log(df['I_tan_real'])
df['logI_int'] = np.log(df['I_int_real'])
df['logWage'] = np.log(df['realWage'])
df['logProd'] = np.log(df['Prod'])
df['logFF'] = np.log(df['FF'])
df['logProfit'] = np.log(df['Profit_real'])
df['logM2growth'] = np.log(df['M2']).diff()
#df['logTFP'] = np.log(df['TFP'])

# --- Consutrct log-differenced real variables
df['logDiffOutput'] = df['logOutput'].diff()
df['logDiffCons'] = df['logCons'].diff()
df['logDiffPrice'] = df['logPrice'].diff()
df['logDiffI_tan'] = df['logI_tan'].diff()
df['logDiffI_int'] = df['logI_int'].diff()
df['logDiffWage'] = df['logWage'].diff()
df['logDiffProd'] = df['logProd'].diff()
df['logDiffFF'] = df['logFF'].diff()
df['logDiffProfit'] = df['logProfit'].diff()
df['logDiffM2growth'] = df['logM2growth'].diff()
#df['logDiffTFP'] = df['dtfp']
df['logDiffTFP'] = df['dtfp_util'] /400

# --- Consutrct quarter to quarter log-differenced real variables
df['logDiffOutput'] = df['logOutput'].diff(4)
df['logDiffCons'] = df['logCons'].diff(4)
df['logDiffPrice'] = df['logPrice'].diff(4)
df['logDiffI_tan'] = df['logI_tan'].diff(4)
df['logDiffI_int'] = df['logI_int'].diff(4)
df['logDiffWage'] = df['logWage'].diff(4)
df['logDiffProd'] = df['logProd'].diff(4)
df['logDiffFF'] = df['logFF'].diff(4)
df['logDiffProfit'] = df['logProfit'].diff(4)
df['logDiffM2growth'] = df['logM2growth'].diff(4)
#df['logDiffTFP'] = df['dtfp']
df['logDiffTFP'] = df['dtfp_util']

# --- Consutrct yearly log-differenced real variables
df['logDiffOutput'] = df['logOutput'].diff()
df['logDiffI_tan'] = df['logI_tan'].diff()
df['logDiffI_int'] = df['logI_int'].diff()
df['logDiffTFP'] = df['dtfp_util']

df.dropna(inplace=True)

# --- Apply HP-filter
for var in ['logOutput', 'logCons', 'logPrice', 'logI_tan', 'logI_int',
            'logWage', 'logProd', 'logFF', 'logProfit', 'logM2growth']:
    cycle, trend = sm.tsa.filters.hpfilter(df[var], 1600)
    df[cycle.name] = cycle
    df[trend.name] = trend

# Some examinations: Correlations b/w HP-cycle and log-diff are low
df[['logOutput_cycle', 'logI_int_cycle', 'logI_tan_cycle', 'logDiffOutput', 'logDiffI_int', 'logDiffI_tan']].corr()
df[['logOutput_cycle', 'logDiffOutput']].plot()
df[['logOutput_cycle', 'logI_int_cycle', 'logI_tan_cycle']].plot()
df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']].plot()
df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan', 'logDiffTFP']].plot()

"""
Estimate VAR using HP-filtered series
"""
dataHP = df[['logOutput_cycle', 'logI_int_cycle', 'logI_tan_cycle']]
dataHP = dataHP[(dataHP.index >= '1983-01-01') & (dataHP.index <= '2007-12-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=25)
irfHP.plot(orth=True)
#irfHP.plot_cum_effects(orth=True)

"""
Estimate VAR using HP-filtered series Low
"""
modelHPL = VAR(dataHP[dataHP.index <= dataHP.index[len(dataHP)//2]])
resultHPL = modelHPL.fit(maxlags=4, ic=None, verbose=True)
resultHPL.summary()

# IRFs
irfHPL = resultHPL.irf(periods=25)
irfHPL.plot(orth=True)
#irfHPL.plot_cum_effects(orth=True)

"""
Estimate VAR using HP-filtered series High
"""
modelHPH = VAR(dataHP[dataHP.index >= dataHP.index[len(dataHP)//2]])
resultHPH = modelHPH.fit(maxlags=4, ic=None, verbose=True)
resultHPH.summary()

# IRFs
irfHPH = resultHPH.irf(periods=25)
irfHPH.plot(orth=True)
#irfHPL.plot_cum_effects(orth=True)

"""
10-series-VAR
"""
dataHP = df[['logOutput_cycle', 'logCons_cycle', 'logPrice_cycle',
             'logI_tan_cycle', 'logI_int_cycle', 'logWage_cycle',
             'logProd_cycle', 'logFF_cycle', 'logProfit_cycle',
             'logM2growth_cycle']]
dataHP = dataHP[(dataHP.index >= '1955-01-01') & (dataHP.index <= '2003-01-01')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=20)
irfHP.plot(orth=True, impulse='logProd_cycle', response='logOutput_cycle')
#irfHP.plot_cum_effects(orth=True)
irfHP.plot(orth=True, impulse='logFF_cycle', response='logProfit_cycle')

"""
Estimate VAR using HP-filtered series Low
"""
modelHPL = VAR(dataHP[dataHP.index <= dataHP.index[len(dataHP)//2]])
resultHPL = modelHPL.fit(maxlags=4, ic=None, verbose=True)
resultHPL.summary()

# IRFs
irfHPL = resultHPL.irf(periods=25)
irfHPL.plot(orth=True, impulse='logProd_cycle', response='logOutput_cycle')
#irfHPL.plot_cum_effects(orth=True)

"""
Estimate VAR using HP-filtered series High
"""
modelHPH = VAR(dataHP[dataHP.index >= dataHP.index[len(dataHP)//2]])
resultHPH = modelHPH.fit(maxlags=4, ic=None, verbose=True)
resultHPH.summary()

# IRFs
irfHPH = resultHPH.irf(periods=25)
irfHPH.plot(orth=True, impulse='logProd_cycle', response='logOutput_cycle')
#irfHPL.plot_cum_effects(orth=True)


"""
7-series-VAR
"""
dataHP = df[['logOutput_cycle', 'logCons_cycle',
             'logI_tan_cycle', 'logI_int_cycle', 'logWage_cycle',
             'logProd_cycle', 'logProfit_cycle']]
dataHP = dataHP[(dataHP.index >= '1959-01-01') & (dataHP.index <= '2007-01-01')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=25)
irfHP.plot(orth=True, impulse='logOutput_cycle', response='logOutput_cycle')
#irfHP.plot_cum_effects(orth=True)

"""
Estimate VAR using HP-filtered series Low
"""
modelHPL = VAR(dataHP[dataHP.index <= dataHP.index[len(dataHP)//2]])
resultHPL = modelHPL.fit(maxlags=4, ic=None, verbose=True)
resultHPL.summary()

# IRFs
irfHPL = resultHPL.irf(periods=25)
irfHPL.plot(orth=True, impulse='logProd_cycle', response='logOutput_cycle')
#irfHPL.plot_cum_effects(orth=True)

"""
Estimate VAR using HP-filtered series High
"""
modelHPH = VAR(dataHP[dataHP.index >= dataHP.index[len(dataHP)//2]])
resultHPH = modelHPH.fit(maxlags=4, ic=None, verbose=True)
resultHPH.summary()

# IRFs
irfHPH = resultHPH.irf(periods=25)
irfHPH.plot(orth=True, impulse='logProd_cycle', response='logOutput_cycle')
#irfHPL.plot_cum_effects(orth=True)

"""
Estimate 3-VAR using 400*log-differenced series
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP = df[['logDiffI_int', 'logDiffI_tan', 'logDiffOutput']]
dataHP = dataHP[(dataHP.index >= '1955-01-01') & (dataHP.index <= '2003-01-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=16)
irfHP.plot(orth=True)
irfHP.plot_cum_effects(orth=True)

irfHP.plot(orth=False, impulse='logDiffOutput')
irfHP.plot_cum_effects(orth=False, impulse='logDiffOutput')

irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput', response='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput', response='logDiffI_tan')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput', response='logDiffI_int')

# customized irfs
pd.Series(irfHP.orth_irfs[0:21,0,0]).plot()
pd.Series(irfHP.orth_irfs[0:21,1,0]).plot()
pd.Series(irfHP.orth_irfs[0:21,2,0]).plot()
pd.Series(irfHP.orth_irfs[0:21,2,2]).plot()

pd.Series(irfHP.orth_cum_effects[0:21,0,0]).plot()
pd.Series(irfHP.orth_cum_effects[0:21,1,0]).plot()
pd.Series(irfHP.orth_cum_effects[0:21,2,0]).plot()

# output to output
temp=irfHP.errband_mc(repl=1000, orth=True)
pd.Series(temp[0][0:21,0,0]).plot()
pd.Series(temp[1][0:21,0,0]).plot()
pd.Series(irfHP.orth_irfs[0:21,0,0]).plot()

# cumulative output to output
temp=irfHP.cum_errband_mc(repl=1000, orth=True)
pd.Series(temp[0][0:21,0,0]).plot()
pd.Series(temp[1][0:21,0,0]).plot()
pd.Series(irfHP.orth_cum_effects[0:21,0,0]).plot()

"""
Estimate 3-VAR using 400*log-differenced series High
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP_H = dataHP[(dataHP.index >= '1979-01-01') & (dataHP.index <= '2003-01-31')]
modelHP_H = VAR(dataHP_H)
resultHP_H = modelHP_H.fit(maxlags=4, ic=None, verbose=True)
resultHP_H.summary()

# IRFs
irfHP_H = resultHP_H.irf(periods=16)
irfHP_H.plot(orth=True)
irfHP_H.plot_cum_effects(orth=True)

irfHP_H.plot(orth=False, impulse='logDiffOutput')
irfHP_H.plot_cum_effects(orth=False, impulse='logDiffOutput')

"""
Estimate 3-VAR using 400*log-differenced series Low
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP_L = dataHP[(dataHP.index >= '1955-01-01') & (dataHP.index <= '1979-01-31')]
modelHP_L = VAR(dataHP_L)
resultHP_L = modelHP_L.fit(maxlags=4, ic=None, verbose=True)
resultHP_L.summary()

# IRFs
irfHP_L = resultHP_L.irf(periods=16)
irfHP_L.plot(orth=True)
irfHP_L.plot_cum_effects(orth=True)

irfHP_L.plot(orth=False, impulse='logDiffOutput')
irfHP_L.plot_cum_effects(orth=False, impulse='logDiffOutput')

"""
Plot
"""
plt.style.use('ggplot')

# confidence bands
irfHP_H_band=irfHP_H.errband_mc(repl=1000, orth=True)
irfHP_L_band=irfHP_L.errband_mc(repl=1000, orth=True)
pd.Series(irfHP_L_band[0][0:21,2,2][:10]).plot()
pd.Series(irfHP_L_band[1][0:21,2,2][:10]).plot()
pd.Series(irfHP_H_band[0][0:21,2,2][:10]).plot()
pd.Series(irfHP_H_band[1][0:21,2,2][:10]).plot()

# irfs
pd.Series(irfHP_H.orth_irfs[0:21,2,2][:10]).plot()
#pd.Series(irfHP.orth_irfs[0:21,2,2][:10]).plot()
pd.Series(irfHP_L.orth_irfs[0:21,2,2][:10]).plot()
plt.legend(['High intangible share', 
            #'M', 
            'Low intangible share'])
plt.title('Impulse responses of output shock to output')

# normalized by period 0
pd.Series(irfHP_H.orth_irfs[0:21,2,2][:10]/irfHP_H.orth_irfs[0:21,2,2][0]).plot()
#pd.Series(irfHP.orth_irfs[0:21,2,2][:10]).plot()
pd.Series(irfHP_L.orth_irfs[0:21,2,2][:10]/irfHP_L.orth_irfs[0:21,2,2][0]).plot()
plt.legend(['High intangible share', 
            #'M', 
            'Low intangible share'])
plt.title('Impulse responses of output shock to output (normalized)')

# cumulative irfs
pd.Series(irfHP_H.orth_cum_effects[0:21,2,2]).plot()
#pd.Series(irfHP.orth_cum_effects[0:21,2,2]).plot()
pd.Series(irfHP_L.orth_cum_effects[0:21,2,2]).plot()
plt.legend(['High intangible share', 
            #'M', 
            'Low intangible share'])
plt.title('Cumulative responses of output shock to output')

# normalized by period 0
pd.Series(irfHP_H.orth_cum_effects[0:21,2,2]/irfHP_H.orth_cum_effects[0:21,2,2][0]).plot()
#pd.Series(irfHP.orth_cum_effects[0:21,2,2]).plot()
pd.Series(irfHP_L.orth_cum_effects[0:21,2,2]/irfHP_L.orth_cum_effects[0:21,2,2][0]).plot()
plt.legend(['High intangible share',
            #'M', 
            'Low intangible share'])
plt.title('Cumulative responses of output shock to output (normalized)')

"""
Estimate 3-VAR using 400*log-differenced series H
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP = dataHP[(dataHP.index >= '1987-01-01') & (dataHP.index <= '2003-01-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=16)
irfHP.plot(orth=True)
irfHP.plot_cum_effects(orth=True)

irfHP.plot(orth=True, impulse='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput')

"""
Estimate 3-VAR using 400*log-differenced series M
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP = dataHP[(dataHP.index >= '1971-01-01') & (dataHP.index <= '1987-01-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=16)
irfHP.plot(orth=True)
irfHP.plot_cum_effects(orth=True)

irfHP.plot(orth=True, impulse='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput')

"""
Estimate 3-VAR using 400*log-differenced series L
"""
dataHP = df[['logDiffOutput', 'logDiffI_int', 'logDiffI_tan']]
dataHP = df[['logDiffI_tan', 'logDiffI_int', 'logDiffOutput']]
dataHP = dataHP[(dataHP.index >= '1955-01-01') & (dataHP.index <= '1971-01-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=16)
irfHP.plot(orth=True)
irfHP.plot_cum_effects(orth=True)

irfHP.plot(orth=True, impulse='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput')

"""
Estimate 4-VAR using 400*log-differenced series
"""
dataHP = df[['logDiffTFP', 
             'logDiffI_int', 'logDiffI_tan', 'logDiffOutput']]
dataHP = dataHP[(dataHP.index >= '1979-01-01') & (dataHP.index <= '2003-01-31')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=16)
irfHP.plot(orth=True)
irfHP.plot_cum_effects(orth=True)

irfHP.plot(orth=True, impulse='logDiffTFP')
irfHP.plot_cum_effects(orth=True, impulse='logDiffTFP')

irfHP.plot(orth=True, impulse='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput')

"""
7-series-VAR using 400*log-differenced series
"""
dataHP = df[['logDiffOutput', 'logDiffCons',
             'logDiffI_tan', 'logDiffI_int', 'logDiffWage',
             'logDiffProd', 'logDiffProfit']]
dataHP = dataHP[(dataHP.index >= '1983-01-01') & (dataHP.index <= '2007-01-01')]
modelHP = VAR(dataHP)
resultHP = modelHP.fit(maxlags=4, ic=None, verbose=True)
resultHP.summary()

# IRFs
irfHP = resultHP.irf(periods=20)
irfHP.plot(orth=True, impulse='logDiffOutput', response='logDiffOutput')
irfHP.plot_cum_effects(orth=True, impulse='logDiffOutput', response='logDiffOutput')