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

# input parameters
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
delta_h <- -0.002 # inches
T_R <- 70 # degF, expected working temp

p_torque_f <- function(Gamma_Max) 2*Gamma_Max/(mu_s*L*pi*D_SOR^2)
p_des <- p_torque_f(Gamma_Max=200*12)
D_HIR_vec <- seq(from=D_SOR-0.01, to=D_SOR, length.out=1e3)

# get the interference pressure from the diameters
p_int_f <- function(D_SO, D_SI, D_HO, D_HI)
	(D_SO - D_HI) / (
		D_HI/E_H*((D_HO^2+D_HI^2)/(D_HO^2-D_HI^2)+nu_H)
		+D_SO/E_S*((D_SO^2+D_SI^2)/(D_SO^2-D_SI^2)-nu_S)
		)

p_vec <- p_int_f(D_SOR, D_SIR, D_HOR, D_HIR_vec)
# plot(D_HIR_vec, p_vec, type='l')
# abline(h=p_des)

# lazy root finding
D_HIR <- D_HIR_vec[which.min(abs(p_des-p_vec))]
cat('calculated inner hub diameter at room temp: ', D_HIR, '\n')
# round to nearest thou
D_HIR <- round(D_HIR*1e3)/1e3

T_h_prescribed <- T_R+(delta_h-D_SOR+D_HIR)/(alpha_S*D_SOR-alpha_H*D_HIR)
delta_R <- D_SOR-D_HIR
Gamma_Max <- p_des*mu_s*L*pi*D_SOR^2/2

# report values:
cat('assembly clearance: ', -delta_h, '\n')
cat('working-temp interference: ', delta_R, '\n')
cat('hub inner diameter (room temp): ', D_HIR, '\n')
cat('shaft outer diameter (room temp): ', D_SOR, '\n')
cat('working temp restraining torque: ', Gamma_Max, '\n')
cat('required temp to achive assembly clearance: ', T_h_prescribed, '\n')
