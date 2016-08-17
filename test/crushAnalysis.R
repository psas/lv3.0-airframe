#!/usr/bin/Rscript
#LV3: Crush Testing analysis
#Joe Shields
#2016-5-1

#setwd("~/Github/PSAS/lv3.0-airframe/test")
# op <- options(digits.secs=3)
# dat.10 <- read.csv(commandArgs(T))

# pdf("crushAnalysis.pdf")

# read and format the data from LU16.10
dat.10 <- read.csv("LV3_LU16-10_ultimateFailure.txt", skip= 5)
# dat.10$Time <- paste("2016-04-29", dat.10$Time)
# dat.10$Time <- strptime(dat.10$Time, format = "%Y-%m-%d %I:%M:%OS")
dat.10$Time <- as.POSIXct(dat.10$Time, format = "%I:%M:%OS")
op <- options(digits.secs=3)
cal.10 <- -308/0.027 #conversion from volts to micro strain
dat.10$Voltage_0.Voltage. <- cal.10*dat.10$Voltage_0.Voltage.
dat.10$Voltage_1.Voltage. <- cal.10*dat.10$Voltage_1.Voltage.
colnames(dat.10) <- c("Row", "Time", "BottomGauge", "MiddleGauge", "empty", "LoadKips")
ind.ult.10 <- which.max(dat.10$BottomGauge)
dat.10 <- dat.10[1:ind.ult.10, ]

# read data for LU16.20
dat.20 <- read.csv("LU16-20_crushTest.csv", skip=5)
dat.20.cal <- data.frame(v=c(0, 0.219, 0.442, 0.665, 0.893), L=c(0.91, 5.81, 10.74, 15.50, 20.76)-0.91)
cal.20.lm <- lm(L~v, data=dat.20.cal)
# summary(cal.20.lm)
# confint(cal.20.lm)
cal.20 <- cal.20.lm$coefficients[["v"]]
dat.20$Time <- as.POSIXct(dat.20$Time, format = "%I:%M:%OS")
dat.20$Load <- -cal.20*dat.20$Voltage_0.Voltage.
ind.ult.20 <- which.max(dat.20$Load)

# plot data for LU16.20
plot(
	dat.20$Time, dat.20$Load,
	type="l",
	main= "loading for LU16.20\n(18\" radome)",
	xlab= "time (mm:ss)",
	ylab= "load (kip)"
	)
points(dat.20$Time[ind.ult.20], dat.20$Load[ind.ult.20], pch=4)
grid()

# plot data for LU16.10
plot(
     dat.10$Time, dat.10$BottomGauge, 
     type="l",
     main="strain for LU16.10\n(18\" CF)",
     xlab="time (mm:ss)",
     ylab= 'micro-strain'
     )
lines(dat.10$Time, dat.10$MiddleGauge)
points(dat.10$Time[ind.ult.10], dat.10$BottomGauge[ind.ult.10], pch=4)
points(dat.10$Time[ind.ult.10], dat.10$MiddleGauge[ind.ult.10], pch=4)
# lines(dat.10$Time, dat.10$LoadKips*1e3)
grid()

plot(
     dat.10$Time, dat.10$Load,
     type="l",
     xlab= "time (mm:ss)",
     ylab="load (kip)",
     main= "loading for LU16.10"
     )
points(dat.10$Time[ind.ult.10],dat.10$Load[ind.ult.10], pch=4)
grid()

# plot(
# 	dat.10$Time, dat.10$LoadKips*1e3, 
# 	xlim=c(dat.10$Time[1], dat.10$Time[1]+5*60),
# 	ylim=c(-500,1.2e3),
# 	type="l"
# 	)
# lines(dat.10$Time, dat.10$BottomGauge)

require("tikzDevice")
tikz("../doc/paper/strain.tex", width = 4, height= 3, packages = c("\\usepackage{tikz}", "\\usepackage{siunitx}"))
par.old <- par(mar=c(4,4,1,0))

mm <- lm(LoadKips~MiddleGauge, data = dat.10)
plot(
     dat.10$MiddleGauge, dat.10$LoadKips, 
     type="l", bty="n", col=NA, 
     xlim=range(dat.10$BottomGauge), 
     # main= "load-strain for LU16.10",
     xlab= "micro-strain",
     ylab= "load (\\si{kip})"
     )
abline(mm, col="red")
points(dat.10$MiddleGauge[ind.ult.10], dat.10$LoadKips[ind.ult.10], pch=4)
lines(dat.10$MiddleGauge, dat.10$LoadKips, col="blue")
# summary(mm)

# plot(dat.10$BottomGauge, dat.10$LoadKips, type="l", bty="n")
mb <- lm(LoadKips~BottomGauge, data = dat.10)
abline(mb, col="red")
points(dat.10$BottomGauge[ind.ult.10], dat.10$LoadKips[ind.ult.10], pch=4)
lines(dat.10$BottomGauge, dat.10$LoadKips, col="green")
# grid()

legend(
       "bottomright",
       col=c("blue","green", "red", "black"),
       legend=c("middle gauge", "edge gauge", "best fit", "failure"),
       lty=c(1, 1, 1, NA),
       pch= c(NA, NA, NA, 4)
       )

par(par.old)
dev.off()

cat("\n----------", "LU16.10 (18\" CF, blue)", "----------\n")
cat("\nLikely load cell offset is between \n", mm$coeff["(Intercept)"], "\nand\n", mb$coeff["(Intercept)"], "\n")
cat(
    "\nultimate load: ", dat.10$Load[ind.ult.10]-mb$coeff["(Intercept)"], "kip",
    "\npinging load: ~7 kip",
    "\nultimate micro-strain (edge): ", dat.10$BottomGauge[ind.ult.10],
    "\nultimate micro-strain (middle): ", dat.10$MiddleGauge[ind.ult.10],
    "\nload per micro-strain (edge): ", mb$coeff["BottomGauge"],
    "\nload per micro-strain (middle): ", mm$coeff["MiddleGauge"],
    "\n"
    )
cat("\n----------", "LU16.20 (18\" radome)", "----------\n")
cat(
    "\nultimate load: ", dat.20$Load[ind.ult.20], "kip",
    "\npinging load: ~2 kip",
    "\n"
    )


# dev.off()
