#
rm(list = ls())

library(mFilter)
library(plm)
library("panelvar")

rdata <- read.csv('http://www.nber.org/nberces/nberces5811/sic5811.csv')

pd <- pdata.frame(rdata, index=c('sic', 'year'))

#paneldata$emplag <- lag(paneldata$emp, k=1)

pd$output <- log(pd$vadd / pd$piship)
pd$capital <- log(pd$cap)
pd$gcapital <- log(pd$cap + pd$invent / pd$piship)
pd$inv <- log(pd$invest / pd$piinv)

pd$dln_output <- diff(pd$output)
pd$dln_capital <- diff(pd$capital)
pd$dln_gcapital <- diff(pd$gcapital)
pd$dln_inv <- diff(pd$inv)

data.pvar <- pd[,c('sic', 'year', 'dln_capital', 'dln_gcapital', 'dln_inv', 'dln_output')]

# plot(pd[pd$sic == 2011, 'dln_inv'])
# plot(pd[pd$sic == 2011, 'dln_output'])
# plot(pd[pd$sic == 2011, 'dln_capital'])

############### gmm log diff
results <-
  pvargmm(dependent_vars = c("dln_inv", "dln_output"),
          lags = 1,
          transformation = "fd",
          data = data.pvar,
          panel_identifier=c("sic", "year"),
          steps = c("twostep"),
          system_instruments = FALSE,
          max_instr_dependent_vars = 99,
          max_instr_predet_vars = 99,
          min_instr_dependent_vars = 2L,
          min_instr_predet_vars = 1L,
          collapse = FALSE
  )
summary(results)

############### log diff
results <-
  pvarfeols(dependent_vars = c("dln_output", "dln_inv"),
            lags = 4,
            transformation = "demean",
            data = data.pvar,
            panel_identifier= c("sic", "year"))
summary(results)

irfs<-oirf(results, n.ahead=20)
plot(oirf(results, n.ahead=20))
plot(stability(results))

# cumulative irf
plot(cumsum(irfs[["dln_output"]][,"dln_inv"]))

####### level
results <-
  pvarfeols(dependent_vars = c("inv", "output"),
            lags = 4,
            transformation = "demean",
            data = pd,
            panel_identifier= c("sic", "year"))
summary(results)

irfs<-oirf(results, n.ahead=25)
plot(oirf(results, n.ahead=25))
plot(stability(results))
