#!/usr/bin/Rscript
#LV3: Crush Testing analysis
#Joe Shields
#2016-5-1

setwd("~/PSAS/sw-cad-airframe-lv3.0/testing")
# op <- options(digits.secs=3)
# dat <- read.csv(commandArgs(T))

# read and format the data
dat <- read.csv("LV3_LU16-10_ultimateFailure.txt", skip= 5)
# dat$Time <- paste("2016-04-29", dat$Time)
# dat$Time <- strptime(dat$Time, format = "%Y-%m-%d %I:%M:%OS")
dat$Time <- as.POSIXct(dat$Time, format = "%I:%M:%OS")
op <- options(digits.secs=3)
cal <- -308/0.027 #conversion from volts to micro strain
dat$Voltage_0.Voltage. <- cal*dat$Voltage_0.Voltage.
dat$Voltage_1.Voltage. <- cal*dat$Voltage_1.Voltage.
colnames(dat) <- c("Row", "Time", "BottomGauge", "MiddleGauge", "empty", "LoadKips")
ind.ult <- which.max(dat$BottomGauge)
dat <- dat[1:ind.ult, ]

plot(dat$Time, dat$BottomGauge, type="l")
lines(dat$Time, dat$MiddleGauge)
points(dat$Time[ind.ult], dat$BottomGauge[ind.ult], pch=4)
points(dat$Time[ind.ult], dat$MiddleGauge[ind.ult], pch=4)
# lines(dat$Time, dat$LoadKips*1e3)

# plot(
# 	dat$Time, dat$LoadKips*1e3, 
# 	xlim=c(dat$Time[1], dat$Time[1]+5*60),
# 	ylim=c(-500,1.2e3),
# 	type="l"
# 	)
# lines(dat$Time, dat$BottomGauge)

mm <- lm(LoadKips~MiddleGauge+0, data = dat)
plot(dat$MiddleGauge, dat$LoadKips, type="l", bty="n", col=NA, xlim=range(dat$BottomGauge))
abline(mm, col="red")
points(dat$MiddleGauge[ind.ult], dat$LoadKips[ind.ult], pch=4)
lines(dat$MiddleGauge, dat$LoadKips)
summary(mm)

# plot(dat$BottomGauge, dat$LoadKips, type="l", bty="n")
mb <- lm(LoadKips~BottomGauge+0, data = dat)
abline(mb, col="red")
points(dat$BottomGauge[ind.ult], dat$LoadKips[ind.ult], pch=4)
lines(dat$BottomGauge, dat$LoadKips)
