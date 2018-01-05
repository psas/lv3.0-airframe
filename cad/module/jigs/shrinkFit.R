# subscript conventions:
# S: shaft
# H: hub
# O: outer
# I: inner
# R: room temp
# h: high temp
# Max: maximum
# Min: minimum
# f: is a function
# fg: is a function generator


p_int_f <- function(D_SO, D_SI, D_HO, D_HI)
# get the interference pressure from the diameters
{
	(D_SO - D_HI) / (
		D_HI/E_H*((D_HO^2+D_HI^2)/(D_HO^2-D_HI^2)+nu_H)
		+D_SO/E_S*((D_SO^2+D_SI^2)/(D_SO^2-D_SI^2)-nu_S)
		)
}

# interference pressure as a function of D_HIR
p_int_fDHIR <- function(D_HIR) P_int_f(D_SO=D_SOR, D_SI=D_SIR, D_HO=D_HOR, D_HI=D_HIR)

# interference pressure as a function of retaining torque
p_torque_f <- function(Gamma_Max) 2*Gamma_Max/(mu_s*L*pi*D_SOR^2)

D_HIR_f <- function(D_SOR, D_SIR, D_HOR, p, verbose=F)
# Get hub's inner diameter at room temp.
# Use the other room temp diameters and the desired interference pressure.
# This uses a root finder, which is inefficient, but easier than CAS.
# It may also be more efficient than CAS, lol.
{
	intervalPads <- c(0.9, 1.1)
	r <- uniroot( # find the D_HIR corresponding to the desired p
		     f= function(D_HIR) p_int_f(D_SOR, D_SIR, D_HOR, D_HIR)-p,
		     interval= D_SOR*intervalPads
		     )
	if (verbose) print(r)
	return(r$root)
}

# diameter of a cylinder as a function of temperature
D_f <- function(alpha, T_h, T_R, D_SOR) alpha*(T_h-T_R)*D_SOR-D_SOR

T_h_fdG <- function(delta_h, Gamma_Max)
{
	p <- p_torque_f(Gamma_Max)
	cat('design pressure is ', p, '\n')
	D_HIR <- D_HIR_f(D_SOR, D_SIR, D_HOR, p)
	cat('D_HIR is ', D_HIR, '\n')
	T_R+(delta_h-D_SOR+D_HIR)/(alpha_S*D_SOR-alpha_H*D_HIR)
}

nu_H <- 0.33 # Poisson's number for the hub
nu_S <- 0.35 # Poisson's number for the shaft
E_H <- 10e6 # psi, modulus of elasticity of the hub
E_S <- 29e6 # psi, modulus of elasticity of the shaft
mu_s <- 0.47 # unitless, static coefficient of friction (hub and shaft)
D_SOR <- 0.375 # inches, shaft outer diameter at room temp
D_HOR <- 0.650 # inches, hub outer diameter at room temp
D_SIR <- 0.120 # inches, shaft inner diameter at room temp
L <- 1 # inches, interface length
alpha_H <- 13.5e-6 # 1/degF, CTE fo the hub
alpha_S <- 5.6e-7 # 1/degF, CTE fo the shaft
delta_h <- 0.003 # inches
T_R <- 70

p_des <- p_torque_f(Gamma_Max=200*12)
D_HIR_vec <- seq(from=D_SOR-0.01, to=D_SOR, length.out=300)
p_vec <- p_int_f(D_SOR, D_SIR, D_HOR, D_HIR_vec)
plot(D_HIR_vec, p_vec, type='l')
abline(h=p_des)

D_HIR <- D_HIR_vec[which.min(abs(p_des-p_vec))]
D_HIR <- D_SOR-0.005

T_R+(delta_h-D_SOR+D_HIR)/(alpha_S*D_SOR-alpha_H*D_HIR)

# D_HIR <- 0.370
# D_SOR - D_HIR
# D_HIR/E_H*((D_HOR^2+D_HIR^2)/(D_HOR^2-D_HIR^2)+nu_H)
# D_SOR/E_S*((D_SOR^2+D_SIR^2)/(D_SOR^2-D_SIR^2)-nu_S)

# torqueRange <- c(20*12, 200*12)
# torques <- seq(from=torqueRange[1], to=torqueRange[2], length.out=300)
# temps <- sapply(torques, function(G) T_h_f(delta_h, G))
# plot(torques, temps)
