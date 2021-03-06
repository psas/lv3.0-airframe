# Analysis of profilometer measurements for "blue magic" and "black magic" layups
# LV3 capstone
# Joe Shields
# 2016-5-24

#### BOOK KEEPING ####
pdf("profilometerPlot.pdf")
# setwd("~/Github/PSAS/lv3.0-airframe/test/profilometer")
files.txt <- system("ls *.txt", intern=T) #find all the files
datName.list <- as.list(files.txt)
# initialize a list of data frames
dat.list <- rep(list(data.frame()), length(datName.list))
# assign names to the list (allows $ indexing)
names(dat.list) <- sub(".txt", datName.list, replacement = "")
# read all the CSVs into the list of data frames
for (i in 1:length(dat.list))
	dat.list[[i]] <- read.csv(
				datName.list[[i]], 
				sep=",", 
				comment.char = "#", 
				col.names = c("x.um", "y.ang")
				)
# figure out which datasets correspond to which layup
is8 <- grepl("^LU16\\.8", datName.list)
is10 <- grepl("^LU16\\.10", datName.list)
# assign color attributes to the respective layups
for (i in 1:length(dat.list)){
	if (is8[i])
		attr(dat.list[[i]], "col") <- "black"
	if (is10[i])
		attr(dat.list[[i]], "col") <- "blue"
}
# truncate all the names into just the describe-y parts
for (i in 1:length(dat.list)){
	attr(dat.list[[i]], "description") <- sub("LU16.*_", names(dat.list), replacement = "")[i]
}
# remove the "DC offset" from all the datasets
for (i in 1:length(dat.list))
	dat.list[[i]]$y.ang <- dat.list[[i]]$y -mean(dat.list[[i]]$y)

#### PLOTTING ####
#initialize the plot
op <- par(mar=c(5,4,4,4))
plot(
	1,1, 
	col=NA, 
	xlim=c(0,5e3), ylim=range(dat.list),
	xlab= "um", ylab="Angstroms",
	main= "profilometer data for LU16.8 and LU16.10\n(various levels of sanding)"
	)
# plot all the datasets
for (i in 1:length(dat.list))
	lines(
		dat.list[[i]]$x, dat.list[[i]]$y, 
		col= attr(dat.list[[i]], "col")
		)
legend(
	"bottom",
	legend= c("LU16.8", "LU16.10"),
	col=c("black", "blue"),
	lty=1
)
# for (i in 1:length(dat.list))
# 	text(
# 		x=dat.list[[i]]$x[length(dat.list[[i]]$x)],
# 		y=dat.list[[i]]$y[length(dat.list[[i]]$y)],
# 		labels= attr(dat.list[[i]], "desc"),
# 		pos= 4,
# 		col= attr(dat.list[[i]], "col")
# 		)
# label the "ideal" cases for each layup type
text(x=500, y=5e5, labels="ideal", col="blue")
arrows(500, 4.5e5, 900, 0, col="blue")
text(x=3500, y=7e5, labels="ideal", col="black")
arrows(c(3700, 3300), c(7e5, 7e5), c(4000, 2350), c(4.8e5, 8.1e5))

# add an axis label in thousanths
thouRange <- range(dat.list)*1e-10/2.54e-5
par(new=T)
plot(c(0,0), thouRange, col=NA, xaxt="n", yaxt="n", xlab="", ylab="", bty="n")
axis(4)
mtext("thousanths",side=4,line=3)
# take the color attribute and apply it to every observation (for a box plot)
# for (i in 1:length(dat.list))
# 	dat.list[[i]]$col <- attr(dat.list[[i]], "col")
# boxp.frame <- data.frame()
# put all the data frames together
# for (i in 1:length(dat.list))
# 	boxp.frame <- rbind(boxp.frame, dat.list[[i]])
# boxp.frame$col <- factor(boxp.frame$col)
# boxplot(y.ang~col, data=boxp.frame)
# hist(boxp.frame$y.ang[boxp.frame$col=="black"])
# hist(boxp.frame$y.ang[boxp.frame$col=="blue"])

#### REPORTING ####
# worst and best case scenarios for feature height
case.worst <- 1e-10*diff(range(dat.list$LU16.8circum_dryToWet$y.ang))
case.best <- 1e-10*diff(range(dat.list$LU16.10axial_sandedCell$y.ang))
# report worst/best cases
cat(
	"worst case feature height (m):\n", formatC(case.worst, format="E"),
	"\nbest case feature height (m):\n", case.best,
	"\nratio:\n",
	case.worst/case.best,"\n"
)
dev.off()

#----------make the plot for the paper----------

downsample <- function(dat, n) 
{
	sparse <- floor(seq(from=1, to= length(dat[,1]), length.out=n))
	return(dat[sparse,])
}
dat.list[[8]] <- downsample(dat.list[[8]], 1e3)
dat.list[[2]] <- downsample(dat.list[[2]], 1e3)

# install.packages("tikzDevice")
require("tikzDevice")
#tikz("../../doc/paper/roughness.tex", width = 4, height= 3, packages = c("\\usepackage{tikz}", "\\usepackage{siunitx}"))
par.old <- par(mar=c(4,4,1,0))
plot(
	dat.list[[8]]$x, dat.list[[8]]$y*1e-4, 
	type="l", bty="n",
	xlab= "length ($\\si{\\micro\\meter}$)",
	ylab= "height ($\\si{\\micro\\meter}$)"
	)
lines(dat.list[[2]]$x, dat.list[[2]]$y*1e-4, col="blue", lty=2)
# legend(
# 	"topleft",
# 	legend= c("uncoated", "adhesive coated"),
# 	col= c("black", "blue"),
# 	lty= 1
# 	)
dev.off()
#par(par.old)

# ---------- Make the plot for the poster ----------
# install.packages("tikzDevice")
dat.list[[8]] <- downsample(dat.list[[8]], 300)
dat.list[[2]] <- downsample(dat.list[[2]], 300)
svg("../../doc/poster/roughness.svg", width = 9, height= 9)
# png("../../doc/poster/roughness.png", width = 9, height= 9, units= "in", res= 300)
posterLWD <- 5
par.old <- par(
	mar=c(7,10,1,1),
	lwd=posterLWD, 
	family= "FreeSerif",
	ps=40,
	las=1,
	mgp=c(5,2.5,0),
	lend= 2,
	lheight=0.5
)

plot(
	dat.list[[8]]$x, dat.list[[8]]$y*1e-4, 
	type="l", bty="n",
	xlab= "\nlength (µm)",
	ylab= "height (µm)\n",
	axes= F
)
axis(1, lwd= posterLWD)
axis(2, lwd = posterLWD)
lines(dat.list[[2]]$x, dat.list[[2]]$y*1e-4, col="blue", lty=3)
legend(
	x=150 , y= 90,
	legend= c("uncoated", NA, "coated"),
	col= c("black", NA, "blue"),
	lty= c(1,NA, 3),
	bty="n",
	seg.len = 4.1
	)
dev.off()
par(par.old)
