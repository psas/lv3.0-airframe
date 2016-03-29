# LV3 capstone project
# Joe Shields
# 2016-3-12

# This script is meant to find the optimal placement 
# of an extra spline point for the LV3 nose cone. 
# The curvature of the LD-Haack shape near the tip 
# creates a large error when using evenly distributed 
# sample points to approximate the shape using spline 
# curves. This script compares different placements 
# of an extra sample point, to minimize that error.

OD <- 6.6*25.4e-3#m, outer diameter
R <- OD/2#m, outer radius
# L <- 30*25.4e-3#m, length of nose cone
L <- 5*OD
spline.points <- 11

# LD Haack shape:
theta <- function(x) acos(1-2*x/L)
y <- function(x) R/sqrt(pi)*sqrt(theta(x)-sin(2*theta(x))/2)#von Karman ogive
plot(
	y, xlim=c(0, L),
	asp=1
	)
plot(function(x) -y(x), add=T)
lines( lty=2,
	c(0, L, NA, L, L), 
	c(0, 0, NA,  R, -R )
	)

#func that returns a spline fit of the LD Haack, with an extra
# point p in from the tip
ysp <- function(p){
	xset <- c(0, seq(from=p, to=L, length.out = spline.points-1))
	yset <- y(xset)
	return(splinefun(x = xset, y = yset))
}

# Demo with the point at p=0.03
ys <- ysp(0.03)
plot(ys, add=T)
plot(function(x)ys(x)-y(x))

# i <-1
# errs <- data.frame(p=NULL, err= NULL)
# xtest <- seq(from=0, to=L, length.out = 300)
# plot(function(x) ysp(0)(x) - y(x))
# for (p in seq(from=0.00, to=0.2, by=0.01)){
# 	plot(function(x) ysp(p)(x) - y(x), col=i, add=T)
# 	i <- i+1
# 	errs <- rbind(errs, c(p, max(abs(ysp(p)(xtest) - y(xtest)))))
# }
# colnames(errs) <- c("p", "err")
# min(errs$err)
# which.min(errs$err)

# find where to put p to minimize error
yerrp.helper <- function(p){ 
	xtest <- seq(from=0, to=L, length.out = 1e3)
	max(abs(ysp(p)(xtest) - y(xtest)))
}
yerrp <-function(p) sapply(p, yerrp.helper)
plot(yerrp, xlim= c(0,0.2))
plot(yerrp, xlim= c(0.025, 0.05))
ptest <- seq(from=0, L, length.out = 1e3)
yerrp.test <- yerrp(ptest)
cat("\nmaximum error: ", min(yerrp.test))
popt <- ptest[which.min(yerrp.test)]

plot(function(x) ysp(popt)(x) - y(x))
# the error is within 0.6 mm
plot(
	y, xlim=c(0, L),
	asp=1
)
plot(function(x) -y(x), add=T)
lines( lty=2,
       c(0, L, NA, L, L), 
       c(0, 0, NA,  R, -R )
)
plot(ysp(popt), col="red", add=T)
xset <- c(0, seq(from=popt, to=L, length.out = spline.points-1))
points(xset, y(xset))
cat("\noptimum x placements:\n", xset, "\noptimum y placements:\n", y(xset))

wedgeHalf <- 2*2*pi/360
cat("\nvertices:\nfront nose surface:\n")
for (i in 1:length(xset)){
	cat("(", 
	    xset[i], " ", 
	    y(xset)[i]*cos(wedgeHalf), " ", 
	    y(xset)[i]*sin(wedgeHalf),
	    ")\n", sep="")
}
cat("\nfront bounds\n",
	"(",  L, " ", 2*OD*cos(wedgeHalf), " ", 2*OD*sin(wedgeHalf), ")\n", 
	"(", -OD, " ", 2*OD*cos(wedgeHalf), " ", 2*OD*sin(wedgeHalf), ")\n", 
	"(", -OD, " ", 0, ", ", 0, ")\n",
	sep=""
	)
cat("\nback nose surface:\n")
for (i in 1:length(xset)){
	cat("(", 
	    xset[i], " ", 
	    y(xset)[i]*cos(-wedgeHalf), " ", 
	    y(xset)[i]*sin(-wedgeHalf),
	    ")\n", sep="")
}
cat("\nback bounds\n",
    "(",  L, " ", 2*OD*cos(-wedgeHalf), " ", 2*OD*sin(-wedgeHalf), ")\n", 
    "(", -OD, " ", 2*OD*cos(-wedgeHalf), " ", 2*OD*sin(-wedgeHalf), ")\n", 
    "(", -OD, " ", 0, ", ", 0, ")\n",
    sep=""
)
