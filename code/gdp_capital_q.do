clear all

cd "~/FirmSpecificIntangibleCapital"

import excel "data/gdp_capital_q.xls", firstrow

* Take logs
gen loggdp = log(gdp)
gen logcap = log(capital)
gen logfcap = log(fixed_capital)

* Label variables
label var loggdp "Log GDP"
label var logcap "Log Capital"
label var logfcap "Log Fixed Capital"

* Convert string date into date
gen date = quarterly(substr(Time, 2, .), "QY")
format %tq date*

* Declare data to be time-series data
tsset date, quarterly

* Merge recession dates
merge 1:1 date using data/recession.dta
drop if _merge != 3
drop _merge

* plot log series
egen max = max(loggdp)
egen min = min(logcap)
gen USRECQ_level = max if USRECQ == 1
replace USRECQ_level = min if USRECQ == 0
twoway  (area USRECQ_level date, color(gs14)) (tsline loggdp logcap logfcap, lcolor(blue)), ytitle("") xtitle("")
tsline loggdp logcap logfcap, name(log, replace)

* plot log differenced series
tsline D.loggdp D.logcap D.logfcap, name(logdiff, replace)

* HP filter all of the data
tsfilter hp logGDP logCapital logFixedCapital = loggdp logcap logfcap, smooth(1600)

* BK filter all of the data
tsfilter bk logGDPbk logCapitalbk logFixedCapitalbk = loggdp logcap logfcap

* plot HP filtered log series
summarize logCapital
generate recession = r(max) if USRECQ == 1
replace recession  = r(min) if USRECQ == 0
local min = r(min)
twoway  (area recession date, color(gs14) base(`min')) (tsline logGDP logCapital, lcolor(blue)), ytitle("") xtitle("")


tsline logGDP logCapital logFixedCapital, name(HPfiltered, replace)

* plot BK filtered log series
tsline logGDPbk logCapitalbk logFixedCapitalbk, name(BKfiltered, replace)

* Run VAR (HP filtered) with with 1 to 4 lags.
var logCapital logGDP, lags(1/4)

* Create IRFs (HP filtered)
irf create irf, order(logCapital logGDP) step(20) set("output/figures/outputShockQhp", replace)
irf graph oirf, impulse(logGDP logCapital) byopts(yrescale) name(multiple_hp, replace)
irf graph oirf, impulse(logGDP) response(logCapital) name(individual_hp, replace)

* Run VAR (BK filtered) with with 1 to 5 lags.
var logCapitalbk logGDPbk, lags(1/5)

* Create IRFs (BK filtered)
irf create irf, order(logCapitalbk logGDPbk) step(20) set("output/figures/outputShockQbk", replace)
irf graph oirf, impulse(logGDPbk logCapitalbk) byopts(yrescale) name(multiple_bk, replace)
irf graph oirf, impulse(logGDPbk) response(logCapitalbk) name(individual_bk, replace)

* Run VAR (Log differenced) with with 1 to 4 lags.
var D.logCapital D.logGDP, lags(1/4)

* Create IRFs (HP differenced)
irf create irf, order(D.logCapital D.logGDP) step(20) set("output/figures/outputShockQdiff", replace)
irf graph oirf, impulse(D.logGDP D.logCapital) byopts(yrescale) name(multiple_diff, replace)
irf graph oirf, impulse(D.logGDP) response(D.logCapital) name(individual_diff, replace)
