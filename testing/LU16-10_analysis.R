#!/usr/bin/Rscript
#LV3: Crush Testing analysis
#Joe Shields
#2016-5-1

setwd("~/PSAS/sw-cad-airframe-lv3.0/testing")
# op <- options(digits.secs=3)
# dat <- read.csv(commandArgs(T))

pdf("LU16-10_crushAnalysis.pdf")

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

plot(
     dat$Time, dat$BottomGauge, 
     type="l",
     main="strain for LU16.10",
     xlab="time (mm:ss)",
     ylab= 'micro-strain'
     )
lines(dat$Time, dat$MiddleGauge)
points(dat$Time[ind.ult], dat$BottomGauge[ind.ult], pch=4)
points(dat$Time[ind.ult], dat$MiddleGauge[ind.ult], pch=4)
# lines(dat$Time, dat$LoadKips*1e3)

plot(
     dat$Time, dat$Load,
     type="l",
     xlab= "time (mm:ss)",
     ylab="load (kip)",
     main= "loading for LU16.10"
     )
points(dat$Time[ind.ult],dat$Load[ind.ult], pch=4)

# plot(
# 	dat$Time, dat$LoadKips*1e3, 
# 	xlim=c(dat$Time[1], dat$Time[1]+5*60),
# 	ylim=c(-500,1.2e3),
# 	type="l"
# 	)
# lines(dat$Time, dat$BottomGauge)

mm <- lm(LoadKips~MiddleGauge, data = dat)
plot(
     dat$MiddleGauge, dat$LoadKips, 
     type="l", bty="n", col=NA, 
     xlim=range(dat$BottomGauge), 
     main= "load-strain for LU16.10",
     xlab= "micro-strain",
     ylab= "load (kip)"
     )
abline(mm, col="red")
points(dat$MiddleGauge[ind.ult], dat$LoadKips[ind.ult], pch=4)
lines(dat$MiddleGauge, dat$LoadKips, col="blue")
# summary(mm)

# plot(dat$BottomGauge, dat$LoadKips, type="l", bty="n")
mb <- lm(LoadKips~BottomGauge, data = dat)
abline(mb, col="red")
points(dat$BottomGauge[ind.ult], dat$LoadKips[ind.ult], pch=4)
lines(dat$BottomGauge, dat$LoadKips, col="green")

legend(
       "bottomright",
       col=c("blue","green", "red"),
       legend=c("middle gauge", "edge gauge", "best fit"),
       lty=c(1)
       )

cat("\nLikely load cell offset is between \n", mm$coeff["(Intercept)"], "\nand\n", mb$coeff["(Intercept)"], "\n")
cat(
    "\nultimate load: ", dat$Load[ind.ult]-mb$coeff["(Intercept)"],
    "\nultimate micro-strain (edge): ", dat$BottomGauge[ind.ult],
    "\nultimate micro-strain (middle): ", dat$MiddleGauge[ind.ult],
    "\nload per micro-strain (edge): ", mb$coeff["BottomGauge"],
    "\nload per micro-strain (middle): ", mm$coeff["MiddleGauge"],
    "\n"
    )



dev.off()
