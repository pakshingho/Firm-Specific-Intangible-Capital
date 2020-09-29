clear *

use http://data.nber.org/nberces/nberces5811/sic5811.dta

*tsset sic year
xtset sic year, yearly

gen output = log(vadd / piship)
gen capital = log(cap)
gen gcapital = log(cap + invent / piship)
gen inv = log(invest / piinv)

*gen capital = log(l.cap)
*gen gcapital = log(l.cap + l.invent / piship)
gen dln_output = d.output
gen dln_capital = d.capital
gen dln_gcapital = d.gcapital
gen dln_inv = d.inv

* HP filter
tsfilter hp logOutput logCapital logGcapital logInv = output capital gcapital inv, smooth(6.25) trend(output_trend capital_trend gcapital_trend inv_trend)

* Plot an SIC industry
tsline output capital gcapital inv output_trend capital_trend gcapital_trend inv_trend if sic==3366, name(level, replace)
tsline dln_output dln_capital dln_gcapital dln_inv if sic==3366, name(logdiff, replace)
tsline logOutput logCapital logGcapital logInv if sic==3366, name(hpfiltered, replace)
tsline logOutput logCapital logGcapital logInv, name(hp, replace)

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

*pvarsoc logInv logOutput, maxlag(12) pvaropts(instl(1/12))
pvar logInv logOutput, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf byopt(yrescale) name(hp_4lags, replace)
pvargranger

* Level
pvar capital output, lags(2) instlags(1/2) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(50) oirf byopt(yrescale) name(level_2lags, replace)
pvargranger

pvar inv output, lags(2) instlags(1/2) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(50) oirf byopt(yrescale) name(level_2lags, replace)
pvargranger

* Level more lag instruments
pvar capital output, instlags(1/4)
pvarirf, step(50) oirf mc(200) byopt(yrescale) name(level_ninst, replace)

pvar inv output, instlags(1/4)
pvarirf, step(50) oirf mc(200) byopt(yrescale) name(level_ninst, replace)

* Log diff
*pvarsoc dln_capital dln_output, maxlag(10) pvaropts(instl(1/10))
pvar dln_capital dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf mc(200) byopt(yrescale) name(diff_4lagsgmmclusteryear, replace)
pvargranger

*pvarsoc dln_gcapital dln_output, maxlag(10) pvaropts(instl(1/10))
pvar dln_gcapital dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf mc(200) byopt(yrescale) name(diff_4lagsgmmclusteryeargc, replace)
pvargranger

*pvarsoc dln_inv dln_output, maxlag(10) pvaropts(instl(1/10))
pvar dln_inv dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf mc(200) byopt(yrescale) name(diff_4lagsgmmclusteryear, replace)
pvargranger

pvar dln_capital dln_inv dln_output, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarirf, step(25) oirf byopt(yrescale) name(diff_4lagsgmmclusteryear, replace)




* Alternative order (also hump-shaped)
pvar dln_output dln_capital, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarstable, graph
pvarirf, step(25) oirf mc(200) byopt(yrescale) name(diff_4lagsgmmclusteryearalt, replace)
pvargranger

pvar dln_output dln_capital dln_inv, lags(4) instlags(1/4) gmmstyle vce(cluster sic year)
pvarirf, step(25) oirf byopt(yrescale) name(diff_4lagsgmmclusteryear, replace)

/******************** 
industry by industry 
*********************/
* count number of industry
levelsof sic
display "Number of distinct values of my_variable is: " = r(r)

* plot and save time series
levels sic
foreach s in `r(levels)' {
		tsline dln_output dln_capital if sic==`s', name(logdiff`s', replace) saving(output/figures/indbyind/logdiff`s', replace)
}

* plot and save irf
levels sic
foreach s in `r(levels)' {
		var dln_capital dln_output if sic == `s', lags(1/3)
		irf create irf`s', step(10) set("output/figures/indbyind", replace)
		irf graph oirf, impulse(dln_output) response(dln_capital) name(irf`s', replace) saving(output/figures/indbyind/irf`s', replace)
}

