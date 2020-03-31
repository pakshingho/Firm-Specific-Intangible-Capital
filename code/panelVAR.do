clear all

use http://www.nber.org/nberces/nberces5811/sic5811.dta

*tsset sic year
xtset sic year, yearly

gen output = log(vadd / piship)
gen capital = log(l.cap)
gen gcapital = log(l.cap + l.invent / piship)
gen dln_output = d.output
gen dln_capital = d.capital
gen dln_gcapital = d.gcapital

* HP filter
tsfilter hp logOutput logCapital logGcapital = output capital gcapital, smooth(6.25) trend(output_trend capital_trend gcapital_trend)

* Plot an SIC industry
tsline output capital gcapital output_trend capital_trend gcapital_trend if sic==3366, name(level, replace)
tsline dln_output dln_capital dln_gcapital if sic==3366, name(logdiff, replace)
tsline logOutput logCapital logGcapital if sic==3366, name(hpfiltered, replace)
tsline logOutput logCapital logGcapital, name(hp, replace)

* unit root test
*xtunitroot fisher dln_capital, dfuller lags(1) demean

* order selection
*pvarsoc capital output, maxlag(4) pvaropts(instl(1/4))

* HP filtered
*pvarsoc logCapital logOutput, maxlag(4) pvaropts(instl(1/4))
pvar logCapital logOutput, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(hp_4lags, replace)
pvargranger

pvar logGcapital logOutput, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(hpGc_4lags, replace)
pvargranger

pvar logCapital logOutput if sic==3366, lags(10) instlags(1/10) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(hp_4lagssic3366, replace)
pvargranger

* Level
pvar capital output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf mc(200) byopt(yrescale) name(level_2lags, replace)
pvargranger

* Level more lag instruments
pvar capital output, instlags(1/4)

pvarirf, step(50) oirf mc(200) byopt(yrescale) name(level_ninst, replace)

* Log diff
pvarsoc dln_capital dln_output, pvaropts(instl(1/10))

pvar dln_capital dln_output, lags(4) instlags(1/4) gmmstyle td vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(diff_4lagsgmmclusteryeartd, replace)
pvargranger

pvar dln_capital dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(diff_4lagsgmmclusteryear, replace)
pvargranger

pvar dln_gcapital dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(diff_4lagsgmmclusteryeargc, replace)
pvargranger

* Alternative order
pvar dln_output dln_capital, lags(2)

pvarirf, step(50) oirf mc(200) byopt(yrescale) name(diff_alt_2lags, replace)

* Log diff more lag instruments
pvar dln_capital dln_output, instlags(1/4)

pvarirf, step(50) oirf mc(200) byopt(yrescale) name(diff_ninst, replace)

*filter
