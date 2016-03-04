OD <- 6.5*25.4e-3
R <- OD/2
L <- 30*25.4e-3
theta <- function(x) acos(1-2*x/L)
y <- function(x) R/sqrt(pi)*sqrt(theta(x)-sin(2*theta(x))/2)
plot(y, xlim=c(0,L))#nosecone shape
abline(h=R, v=L)

yp <- function(x) R*sqrt(
	2/L/sqrt(1-(1-2*x/L)^2)
	-2*cos(2*theta(x))/L/sqrt(1-(1-2*x/L)^2)
)/2/sqrt(pi)/sqrt(
	theta(x)-(1/2)*sin(2*theta(x))
)
