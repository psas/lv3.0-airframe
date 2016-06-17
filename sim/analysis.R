#!/usr/bin/Rscript

# Analysis of L-12 Simulation
# LV3 capstone
# Joe Shields
# 2016-1-16
# In Linux (bash), the first line will make this executable from the command line.

#### function definitions ####
source("ORanalysisFunctions.R")
# XYhist <- function(X, Y){
# 	#This makes a weighted histogram of the mach number (the weight is the energy loss due to drag).
# 	Nbins <- 10#number of bins
# 	bins <-   seq(from= min(X), to=max(X), length.out= Nbins+1)#the partitions of the bins
# 	binval <- seq(0,0, length.out= Nbins)#the height assigned to each bin
# 	
# 	for (i in 1:length(X)){ #for each measurement
# 		for (j in 1:length(binval)){ #go from low bins to high
# 			if (X[i]>=bins[j] & X[i]<=bins[j+1]){ #When you're in the current bin
# 				binval[j]= binval[j]+Y[i] #add the current density
# 				break #go to the next measurement
# 			}
# 		}
# 	}
# 	return(data.frame(height= c(binval,0), labels=bins))
# }
# portableLoadHelper <- function(x, repos){
# #Try to load package x. If you can't, install it and then load it.
# 	if (!require(x, character.only = T)){
# 		install.packages(x, repos= repos)
# 		library(x, character.only = T)
# 	}
# }
# portableLoad <- function(x, repos="http://cran.rstudio.com/")
# 	#load a whole vector of package names, as above. 
# 	invisible(sapply(x, function(x) portableLoadHelper(x, repos)))

#### book keeping ####
#wdName <- "~/Github/PSAS/LV3-airframe"
#csvName <- "Launch-12.csv"
#setwd(wdName)
if (!(length(commandArgs(T))==0)) #if arguments were given
	csvName <- commandArgs(T) # take the csv location as the argument
if (!exists("csvName"))
	stop(paste("I need a CSV file from OpenRocket to analyze!",
		   "either do",
		   "./analysis.R simData/YOURSIM.csv",
		   "from your terminal, or in R use",
		   "csvName <- \"simData/YOURSIM.csv\"", 
		   "before calling",
		   "source(\"analysis.R\")",
		   sep="\n"))
simName <- sub(".csv", "", sub(".*/", "", csvName)) #strip away path and extension information
#load packages: gridExtra plots tables; crayon outputs colored text to the terminal
suppressPackageStartupMessages(portableLoad(c("gridExtra", "crayon")))

suppressWarnings(dir.create("plots")) #should just throw a warning if plots/ already exists
plotType <- "pdf"
if (plotType=="png"){
	png(
		paste("plots/", simName, "_analysis_plot%03d.png", sep=""), 
		width <- height <- 500
		)
}else 
	pdf(
		paste("plots/", simName, "_analysis_plot%03d.pdf", sep="")
	)
par(bty="n")#don't put boxes around plots


#### parse the CSV file ####
cat("\nLoading", csvName, "\n")
simStringLines <- readLines(csvName)#read the CSV as a vector of the lines
dat <- read.csv(#load the simulation from a CSV into a data frame
	csvName, 
	comment.char= "#",#ignore commented lines
	nrows= grep("APOGEE", simStringLines)#stop reading [slightly] after apogee
	)
if (!exists("dat")) stop("Couldn't find ", csvName) # check that we sucessfully read the CSV
datNames <- simStringLines[grep("Time", simStringLines)] # extract the column names
datNames <- sub(pattern= "# ", replacement= "", x= datNames) # remove comment char
datNames <- strsplit(datNames, split= ",")[[1]] # break apart into a vector
datNames <- gsub("[^[:alnum:]///' ]", "", datNames)#regex black magic (remove weird chars)
datNames <- sub(pattern= " ", replacement= "_", datNames)#replace spaces with underscores
datNames <- sub(pattern= " ", replacement= "_", datNames)#nonbreaking spaces?
datNames <- sub(pattern= " ", replacement= "_", datNames)#other magical spaces?!
colnames(dat) <- datNames # name the columns


#### plot the important flight variables ####
cat("Plotting flight variables...\n")
plot(# start a plot of the normalized variables as a function of time
	dat$Time, dat$Mach, type="l", col="blue",
	main= paste("Important Flight Variables\nfor", simName),
	xlab= "time (s)",
	ylab= "",
	lwd=3
     )
lines(dat$Time, dat$Total_velocity/max(dat$Total_velocity), col="blue", lty=2, lwd=3)#v*(t)
lines(dat$Time, dat$Altitude/max(dat$Altitude), col="green", lty=3, lwd=3)#h*(t)
lines(dat$Time, dat$Drag_force_N/max(dat$Drag_force_N), col="red", lty=4, lwd=3)#D*(t)
lines(dat$Time, dat$Thrust/max(dat$Thrust), col="red", lty=5, lwd=3)#F*(t)
lines(dat$Time, dat$Stability, col="green", lty=6, lwd=3)
legend(
	"right", 
	legend=	 c("Mach #", "Speed*", "Altitude*", "Drag Force*", "Thrust*", "Stability", "* relative to max"),
	col=	 c("blue",   "blue",   "green",     "red",          "red",    "green",	   "white"),
	lty=     c(1,        2,        3,           4,              5,        6,	   7),
	lwd=3
	)


#### data reduction ####
cat("Performing data reduction...\n")
#energy lost to drag:
dE.drag <- dat$Drag_force_N*dat$Total_velocity*dat$Simulation_time_step_s
#energy contributed by engine:
dE.thrust <- dat$Thrust*dat$Total_velocity*dat$Simulation_time_step_s
#energy put into height:
dE.grav <- dat$Gravitational_acceleration*dat$Mass_g*1e-3*#grams to kilograms
	dat$Total_velocity*dat$Simulation_time_step_s

report <- data.frame(
	simName,
	csvName, 
	E.drag= formatC(sum(dE.drag)),
	E.engine= formatC(sum(dE.thrust)),
	E.grav= formatC(sum(dE.grav)),
	h.max= max(dat$Altitude)
	)
plot.new()#open a clean plot for the table
grid.table(report)#add the report table to the plot


#### plot weighted histogram ####
cat("Plotting weighted histogram...\n")
Mach.XYbars <- XYhist(dat$Mach_number, dE.drag)
barplot(
	Mach.XYbars$height/1e3, 
	names.arg = formatC(Mach.XYbars$labels, format= "f", digits=2), 
	axisnames =T,
	col="blue",
	xlab= "bin floor Mach number",
	ylab= "Energy lost to drag (kJ)",
	main= "Histogram of Energy Loss\nweighted by Mach number"
	)
#verify that the XYhist method works with an obvious example:
# AltTime.XYbars <- XYhist(dat$Time..s., dat$Altitude..m.)
# barplot(AltTime.XYbars$height)

#### close plot device and export data reduction ####
invisible(dev.off())
cat("Saving data reduction...\n")
suppressWarnings(dir.create("reductions"))
write.csv(report, file=paste("reductions/", simName, "_reduction.csv", sep=""))
cat("Done.", blue("Analysis of", simName, "completed successfully!\n"))
