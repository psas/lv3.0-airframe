# This is a fast/hideous analysis (read: scratch paper)
# of the heating on the nose cone. If you try to just source it,
# I don't think it will work. Long story short, the OpenRocket drag
# and theoretical wave drag don't agree. 

OD <- 6.5*25.4e-3#m, outer diameter
R <- OD/2#m, outer radius
L <- 30*25.4e-3#m, length of nose cone
Ma0 <- 2
alpha <- 0
rho <- 1.0 #kg/m^3, density of air
U <- 740 #m/s, max vel taken from OR sim

theta <- function(x) acos(1-2*x/L)
y <- function(x) R/sqrt(pi)*sqrt(theta(x)-sin(2*theta(x))/2)#von Karman ogive
y.wiki <- function(x) R*(4*x/2/L*(1-x/2/L))^(3/4)#shape from wiki

plot(y, xlim=c(0,L), asp=1)#nosecone shape
lines(c(L,L), c(-R,R))
plot(function(x) -y(x), xlim=c(0,L), add=T)
plot(y.wiki, xlim=c(0,L), col="red", add=T)
plot(function(x) -y.wiki(x), xlim=c(0,L), add=T, col="red")

# #dimensionless, y prime, slope of nose cone
# yp <- function(x) R*sqrt(
# 	2/L/sqrt(1-(1-2*x/L)^2)
# 	-2*cos(2*theta(x))/L/sqrt(1-(1-2*x/L)^2)
# )/2/sqrt(pi)/sqrt(
# 	theta(x)-(1/2)*sin(2*theta(x))
# )
# x <- seq(from=0, to=L, length.out = 1e3)
# yp.sq.bar <- mean( (yp(x)^2)[ !is.nan(yp(x)) ] )#mean value of (y prime)^2, ignoring NaN values
# rm(x)
# 
# CD.wave <- 4/sqrt(Ma0^2-1)*(alpha^2+yp.sq.bar)
# CD.

D.wave <- 9*pi^3*R^4/4/L^2*rho*U^2#wave drag force
D.visc <- dat$Drag_force_N[ind.cr]
Fthrust <- dat$Thrust_N[ind.cr]
# Fthrust-D.wave-D.visc
Acc <- dat$`Total_acceleration_m/s`[ind.cr]
Acc*dat$Mass_g[ind.cr]*1e-3
Fthrust-D.visc-9.81*dat$Mass_g[ind.cr]*1e-3
plot(dat$Time_s, dat$Drag_coefficient_, ylim=c(0,0.5))
points(dat$Time_s[which(dat$Mach>1)], dat$Drag_coefficient_[which(dat$Mach>1)], col="blue")
plot(dat$Time_s, dat$Mach_number_)
plot(dat$Mach, dat$Drag_coefficient_)
plot(dat$Mach, dat$Drag_force_N)
# CD.visc.min <- 

# CD.wave <- 9*pi^2*R^2/2/L^2
# (1/2)*rho*U^2*CD.wave*(pi*R^2)
# ind.cr <- which.max(dat$Mach_number)
# par(mfrow=c(2,1))
# plot(dat$Time_s, dat$`Total_acceleration_m/s`*dat$Mass_g*1e-3, xlim=c(0,8))
# plot(dat$Time_s, dat$`Total_velocity_m/s`)
# dev.off()
# (dat$`Total_acceleration_m/s`*dat$Mass_g*1e-3)[ind.cr]
# dat$Thrust_N[ind.cr]
# dat$Time_s[ind.cr]
# max(dat$Drag_force_N)
# D.tot <- dat$Drag_force_N[ind.cr]
# dat$Air_pressure_mbar[ind.cr]
# dat$Air_temperature_C[ind.cr]
# dat$Altitude_m[ind.cr]

E.tot <- 6.053e6 #J, energy dissipated
E.nose <- E.tot*(D.wave/D.tot)^2
formatC(E.nose)


alpha <- 1.83e-4
heatCap <- 0.91e3 #J/kg/K
rho.al <- 2712#kg/m^3
t.span <- 5#seconds
q.dot <- function(r) alpha*rho^(1/2)*r^(-1/2)*U^3
temp <- function(r) q.dot(r)*t.span/heatCap/(rho.al*4/3*pi*r^3)
plot(temp, xlim=c(0.05, 0.1))
