OD <- 6.6 #m, outer diameter
R <- OD/2 # outer radius
L <- 5*OD

# LD Haack shape:
theta <- function(x) acos(1-2*x/L)
y <- function(x) R/sqrt(pi)*sqrt(theta(x)-sin(2*theta(x))/2)#von Karman ogive
plot(y, xlim=c(0,L), asp=1)
x_samp <- (1:6)/7*L
points(x_samp,y(x_samp))
stations <- data.frame(position=x_samp, diameter=2*y(x_samp))
cat('Make your stations with these dimensions:\n')
print(stations)
