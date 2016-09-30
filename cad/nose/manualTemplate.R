#!/usr/bin/Rscript
# This is just a calculation of some points to manually
# construct a template for the nose cone shell. The reported 
# "x" values are actually the distance along the surface of
# the nose. So, the center of the cutout should lay perfectly 
# along the center of the mold. There's a quarter inch of room
# left along each side, to account for any necessary fudgery.
# Joe Shields
# 2016-9-29

x <- seq(from=0, to=33, length.out = 1e3)
OD <- 6.6#in, outer diameter
R <- OD/2#in, outer radius
# L <- 30*25.4e-3#in, length of nose cone
L <- 5*OD

# LD Haack shape:
theta <- function(x) acos(1-2*x/L)
y <- function(x) R/sqrt(pi)*sqrt(theta(x)-sin(2*theta(x))/2)#von Karman ogive
# plot(
# 	y, xlim=c(0, L),
# 	asp=1
# 	)
x <- seq(from=0, to=L, length.out = 1e3)
yp <- y(x)
# plot(x, yp, type="l")
pow <- 1.3
ind <- ceiling(seq(from=1, to= length(yp), length.out = 5)^pow/length(yp)^(pow-1))
cp <- yp*2*pi

cp <- cp[ind]
xp <- x[ind]

cp <- c(cp, OD*pi)
xp <- c(xp, L+6)

cp <- cp
rcp <- cp/4-0.5
rcp <- (rcp+abs(rcp))/2

arclength <- function(x,y)
{
	ds <- 0
	for(i in 2:length(x))
		ds <- c(ds, sqrt((x[i]-x[i-1])^2+(y[i]-y[i-1])^2))
	s <- cumsum(ds)
	return(s)
}

s <- arclength(x, yp)
length(s)
length(yp)
# plot(s, yp)
sp <- c(s[ind], max(s)+6)

plot(s, yp*2*pi/4, xlim=c(0, L+6), ylim=c(0, 6))
points(sp, rcp)
lines(sp, rcp)
pts <- data.frame(
	x= paste(format(c(sp, rev(sp)), digits=4)), 
	y= paste(format(c(rcp, -rev(rcp)), digits=4))
	)

cat("
Use these coordinates to draw out one side of the cutout of
the nose cone. So, you will draw some cartesian axes on the 
peel ply of the the CF. Then, plot these points. Then, 
connect the points together. Draw lines between the points
with a straight edge. At the tip, construct the necessary 
unfolding for the doodlybob that connects to the nose tip 
and the nose plug. The units are in inches. 
")
# cat("x= ", paste(format(c(sp, rev(sp)), digits=4), collapse=", "))
# cat("\n")
# cat("y= ", paste(format(c(rcp, -rev(rcp)), digits=4), collapse=", "))
print(pts)
