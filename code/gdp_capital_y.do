clear all

cd "~/FirmSpecificIntangibleCapital"

import excel "data/gdp_capital_y.xls", firstrow

* Take logs
gen loggdp = log(gdp)
gen logcap = log(capital)
gen logfcap = log(fixed_capital)

* Label variables
label var loggdp "Log GDP"
label var logcap "Log Capital"
label var logfcap "Log Fixed Capital"

* Convert string date into date
gen date = yearly(Time, "Y")
format %ty date*

* Declare data to be time-series data
tsset date

* plot log series
tsline loggdp logcap logfcap, name(log, replace)

* plot log differenced series
tsline D.loggdp D.logcap D.logfcap, name(logdiff, replace)

* HP filter all of the data
tsfilter hp logGDP logCapital logFixedCapital = loggdp logcap logfcap, smooth(100)

* plot filtered log series
tsline logGDP logCapital logFixedCapital, name(filtered, replace)

* Run VAR (HP filtered) with with 1 to 4 lags.
var logCapital logGDP, lags(1/2)

* Create IRFs (HP filtered)
irf create irf, order(logCapital logGDP) step(20) set("output/figures/outputShockQ", replace)
irf graph oirf, impulse(logGDP logCapital) byopts(yrescale) name(multiple, replace)
irf graph oirf, impulse(logGDP) response(logCapital) name(individual, replace)

* Run VAR (Log differenced) with with 1 to 4 lags.
var D.logCapital D.logGDP, lags(1/2)

* Create IRFs (HP differenced)
irf create irf, order(D.logCapital D.logGDP) step(20) set("output/figures/outputShockQdiff", replace)
irf graph oirf, impulse(D.logGDP D.logCapital) byopts(yrescale) name(multiple_diff, replace)
irf graph oirf, impulse(D.logGDP) response(D.logCapital) name(individual_diff, replace)
