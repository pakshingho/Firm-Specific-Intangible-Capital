# Build VAR model

rm(list = ls())

library(readxl)
library(fredr) # read data using FRED API
library(zoo) # for date conversion
library(mFilter) # for HP-filter
library(vars)

fredr_set_key("8a6156203f03ec0b67fb55533e334fcf")

mdata <- read_excel('FirmSpecificIntangibleCapital/data/gdp_capital_q.xls')

mdata$date <- as.yearqtr(mdata$Time, format = "Q%q-%Y")
rownames(mdata) <- mdata$date
#mdata <- mdata[mdata$date<'2020 Q1',]
mdata$Time <- NULL
mdata$date <- NULL

gdp<-ts(mdata$gdp, start=c(1960, 1), end=c(2021, 4), frequency = 4)
capital<-ts(mdata$capital, start=c(1960, 1), end=c(2021, 4), frequency = 4)
ts.plot(gdp)

gdp.hp<-hpfilter(log(gdp))
capital.hp<-hpfilter(log(capital))
plot(capital.hp, col=1)
plot(gdp.hp, col=1)

output<-ts(gdp.hp$cycle, start=c(1960, 1), end=c(2019, 4), frequency = 4)
capital<-ts(capital.hp$cycle, start=c(1960, 1), end=c(2019, 4), frequency = 4)

data.var <- as.matrix(cbind(capital, output))
#colnames(data.var) <- c('output', 'capital')
results <- VAR(data.var, p=4)
summary(results)

impresp <- irf(results, n.ahead=25, ci=0.95)
plot(impresp)

plot(irf(results, impulse='output', response='capital', n.ahead=25, ci=0.95))

#####################
# Obtain NIPA Series using FRED API
#####################
# GDP
gdp <- fredr(
        series_id = "GDP",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross Private Domestic Investment
inv <- fredr(
        series_id = "GPDI",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products
ip <- fredr(
        series_id = "Y001RC1Q027SBEA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross Domestic Product: Implicit Price Deflator
gdpdef <- fredr(
        series_id = "GDPDEF",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross private domestic investment (implicit price deflator) (A006RD3Q086SBEA)
invdef <- fredr(
        series_id = "A006RD3Q086SBEA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross Private Domestic Investment: Fixed Investment: Nonresidential: Intellectual Property Products: Implicit Price Deflator (Y001RD3Q086SBEA)
ipdef <- fredr(
        series_id = "Y001RD3Q086SBEA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)
# Current-Cost Net Stock of Fixed Assets and Consumer Durable Goods (K1WTOTL1ES000)
cap <- fredr(
        series_id = "K1WTOTL1ES000",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)
gdpa <- fredr(
        series_id = "GDPA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)
# Gross Domestic Product: Implicit Price Deflator
gdpadef <- fredr(
        series_id = "A191RD3A086NBEA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# Gross private domestic investment (implicit price deflator)
invadef <- fredr(
        series_id = "A006RD3A086NBEA",
        observation_start = as.Date("1947-01-01"),
        observation_end = as.Date("2020-01-01")
)

# some level plots
# plot(x=gdp$date, y=(gdp$value), col=1)
# lines(x=inv$date, y=(inv$value), col=2)
# lines(x=ip$date, y=(ip$value), col=3)
# plot(x=gdpdef$date, y=(gdpdef$value), col=1)
# lines(x=invdef$date, y=(invdef$value), col=2)
# lines(x=ipdef$date, y=(ipdef$value), col=3)

# Convert raw data into ts-objects
gdp<-ts(gdp$value, start=c(1947, 1), frequency = 4)
gdpdef<-ts(gdpdef$value, start=c(1947, 1), frequency = 4)
inv<-ts(inv$value, start=c(1947, 1), frequency = 4)
invdef<-ts(invdef$value, start=c(1947, 1), frequency = 4)
ip<-ts(ip$value, start=c(1947, 1), frequency = 4)
ipdef<-ts(ipdef$value, start=c(1947, 1), frequency = 4)

cap<-ts(cap$value, start=c(1947, 1), end=c(2018,1), frequency = 1)
gdpa<-ts(gdpa$value, start=c(1947, 1), end=c(2018,1), frequency = 1)
invadef<-ts(invadef$value, start=c(1947, 1), end=c(2018,1), frequency = 1)
gdpadef<-ts(gdpadef$value, start=c(1947, 1), end=c(2018,1), frequency = 1)

#construct tangible investment deflator and nominal tangible investment
tinv <- inv - ip
tinvdef <- invdef - (ip/ipdef) / (inv/invdef - ip/ipdef) * (ipdef - invdef)
#as.matrix(cbind((inv/invdef - ip/ipdef)*tinvdef, tinv)) # tangible investment deflator verification

# Some interesting findings:
# 1. declining both tangible & intangible investment prices
# 2. intangible price declining faster
# 3. rising nominal intangible investment shares
# 4. 2 & 3 above implies real intangible investment shares rises more rapidly than that of nominal
ts.plot(ipdef/gdpdef-1, col=1, ylab='Ratios')
lines(tinvdef/gdpdef-1, col=2,)
lines(ipdef/tinvdef-1, col=3)
lines(ip/(tinv), col=4)
lines((ip/ipdef)/(tinv/tinvdef), col=5)
lines(inv/gdp, col=6)
lines(tinv/gdp, col=7)
legend('topright', 
       legend=c(expression(P^I.int/P^Y-1), 
                expression(P^I.tan/P^Y-1), 
                expression(P^I.int/P^I.tan-1), 
                expression(I.int/I.tan),
                expression(Real.I.int/Real.I.tan),
                expression(I.both/Y),
                expression(I.tan/Y)
                ),
       col=c(1,2,3,4,5,6,7), lty=rep(1,7), cex=1)
# correlation
cor(cbind(ip/inv, ip/(inv-ip), ipdef/invdef, inv/gdp, invdef/gdpdef))

# how bad to use real total investment - real intangible investment = real tangible investment
ts.plot(ip/inv*(ipdef/invdef-1))

# Create log real variables
gdp<-log(gdp/gdpdef)
inv<-log(inv/invdef)
ip<-log(ip/ipdef)
tinv<-log(inv/invdef - ip/ipdef)

gdpa<-log(gdpa/gdpadef)
cap <- log(cap/invadef)

# Apply HP-filter 
gdp.hp<-hpfilter(gdp)
inv.hp<-hpfilter(inv)
ip.hp<-hpfilter(ip)
tinv.hp<-hpfilter(tinv)

gdpa.hp<-hpfilter(gdpa)
cap.hp<-hpfilter(cap)

output <- gdp.hp$cycle
inv_both <- inv.hp$cycle
inv_tan <- tinv.hp$cycle
inv_int <- ip.hp$cycle

outputa <- gdpa.hp$cycle
capital <- cap.hp$cycle


data.var <- as.matrix(cbind(output, inv_int, inv_tan))
results <- VAR(data.var, p=8)
summary(results)

impresp <- irf(results, n.ahead=25, ci=0.95)
plot(impresp)

plot(irf(results, impulse='output', response='output', n.ahead=25, ci=0.95, cumulative=F))


# log diff
output <- diff(gdp)
inv_both <- diff(inv)
inv_tan <- diff(tinv)
inv_int <- diff(ip)

data.var <- as.matrix(cbind(output, inv_int, inv_tan)) # investment is a decision variable, respond to all shocks
results <- VAR(data.var, p=8)
summary(results)

impresp <- irf(results, n.ahead=25, ci=0.95, cumulative=T)
plot(impresp)

plot(irf(results, impulse='output', response='output', n.ahead=25, ci=0.95, cumulative=T))

# capital
data.var <- as.matrix(cbind(capital, outputa))
results <- VAR(data.var, p=8)
summary(results)

impresp <- irf(results, n.ahead=25, ci=0.95)
plot(impresp)

plot(irf(results, impulse='outputa', response='outputa', n.ahead=25, ci=0.95, cumulative=F))

# capital fd
outputa <- diff(gdpa)
capital <- diff(cap)
data.var <- as.matrix(cbind(outputa, capital))
results <- VAR(data.var, p=8)
summary(results)

impresp <- irf(results, n.ahead=25, ci=0.95)
plot(impresp)

plot(irf(results, impulse='outputa', response='outputa', n.ahead=25, ci=0.95, cumulative=F))
