#############
# Packages
#############
library(coda)
#############
# Random Seed
#############
set.seed(167)
###################################################################################
###
###################################################################################
###
# Solution #1
###################################################################################
###
###################################################################################
###
load(here::here("./bis567/homework/hw04/HW4.RData"))
n <- length(y)
###################################################################################
###
# log_h Function
###################################################################################
###
log_h <- function(log_lambda_val, index) {
    val <- -exp(log_lambda_val) +
        y[index] * log_lambda_val -
        (1 / (2 * sigma2[i - 1])) * (log_lambda_val - beta0[i - 1] - beta1[i -
            1] * x[index])^2
    return(val)
}
###############
# Global Setting
###############
mc_num <- 100000
###############
# Prior Settings
###############
mu <- 0
tau2 <- 100^2
a <- 0.01
b <- 0.01
############################
# Parameters
############################
log_lambda <- rep(0, times = n)
beta0 <- rep(0, times = mc_num)
beta1 <- rep(0, times = mc_num)
sigma2 <- rep(0, times = mc_num)
###############
# Initial Values
###############
sigma2[1] <- 1.00
#######################
# Metropolis Settings
#######################
accept <- rep(1, times = n)
metrop_var <- 0.50
###################
# Main Sampling Loop
###################
for (i in 2:mc_num) {
    ###########################################################################
    # Update log_lambda
    ###########################################################################
    for (j in 1:n) {
        log_lambda_proposed <- rnorm(n = 1, mean = log_lambda[j], sd = sqrt(metrop_var))
        ratio <- exp(log_h(log_lambda_proposed, j) - log_h(log_lambda[j], j))
        if (ratio >= runif(n = 1, min = 0, max = 1)) {
            log_lambda[j] <- log_lambda_proposed
            accept[j] <- accept[j] + 1
        }
    }
    ########################################################################
    # Update beta0
    ########################################################################
    beta0_mean <- (tau2 * sum(log_lambda - x * beta1[i - 1])) / (n * tau2 + sigma2[i - 1])
    beta0_var <- (sigma2[i - 1] * tau2) / (n * tau2 + sigma2[i - 1])
    beta0[i] <- rnorm(
        n = 1,
        mean = beta0_mean,
        sd = sqrt(beta0_var)
    )
    #################################################################################
    # Update beta1
    #################################################################################
    beta1_mean <- (tau2 * sum((log_lambda - beta0[i]) * x)) / (tau2 * (sum(x^2)) + sigma2[i -
        1])
    beta1_var <- (sigma2[i - 1] * tau2) / (tau2 * (sum(x^2)) + sigma2[i - 1])
    beta1[i] <- rnorm(
        n = 1,
        mean = beta1_mean,
        sd = sqrt(beta1_var)
    )
    ##########################################################
    # Update sigma2
    ##########################################################
    a_new <- (n / 2) + a
    b_new <- (sum((log_lambda - beta0[i] - beta1[i] * x)^2) / 2) + b
    sigma2[i] <- 1 / rgamma(
        n = 1,
        shape = a_new,
        rate = b_new
    )
    ########################################################################
    # Printing to the Log
    ########################################################################
    print(c("Minimum log_lambda Acceptance Rate:", round(min(accept / i), 2)))
    print(c("Maximum log_lambda Acceptance Rate:", round(max(accept / i), 2)))
    print(c("Completion %:", round(100 * i / mc_num, 2)))
}
#########################################
# MCMC Diagnostics
#########################################
burnin <- 10000
thin <- 10
keep_set <- seq((burnin + 1), mc_num, thin)
effectiveSize(beta0[keep_set])
effectiveSize(beta1[keep_set])
effectiveSize(sigma2[keep_set])
geweke.diag(beta0[keep_set])
geweke.diag(beta1[keep_set])
geweke.diag(sigma2[keep_set])
par(mfrow = c(3, 2))
plot(beta0[keep_set], type = "l")
acf(beta0[keep_set])
plot(beta1[keep_set], type = "l")
acf(beta1[keep_set])
plot(sigma2[keep_set], type = "l")
acf(sigma2[keep_set])
###################################################################################
##########################
# Inference
###################################################################################
##########################
round(c(mean(beta0[keep_set]), sd(beta0[keep_set]), quantile(
    beta0[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
round(c(mean(beta1[keep_set]), sd(beta1[keep_set]), quantile(
    beta1[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
round(c(mean(sigma2[keep_set]), sd(sigma2[keep_set]), quantile(
    sigma2[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
#################################################################
#################################################################
# Solution #2
#################################################################
#################################################################
n <- length(y)
#################################################################
# log_h Function, phi
#################################################################
log_h_phi <- function(phi_val, index) {
    log_lambda <- beta0[i - 1] + beta1[i - 1] * x[index] + phi_val
    val <- -exp(log_lambda) +
        y[index] * log_lambda -
        (1 / (2 * sigma2[i - 1])) * (phi_val)^2
    return(val)
}
#######################################################
# log_h Function, beta0
#######################################################
log_h_beta0 <- function(beta0_val) {
    log_lambda <- beta0_val + beta1[i - 1] * x + phi
    val <- -sum(exp(log_lambda)) +
        sum(y * log_lambda) -
        (1 / (2 * tau2)) * (beta0_val)^2
    return(val)
}
#####################################################
# log_h Function, beta1
#####################################################
log_h_beta1 <- function(beta1_val) {
    log_lambda <- beta0[i] + beta1_val * x + phi
    val <- -sum(exp(log_lambda)) +
        sum(y * log_lambda) -
        (1 / (2 * tau2)) * (beta1_val)^2
    return(val)
}
###############
# Global Setting
###############
mc_num <- 100000
###############
# Prior Settings
###############
mu <- 0
tau2 <- 100^2
a <- 0.01
b <- 0.01
############################
# Parameters
############################
phi <- rep(0, times = n)
beta0 <- rep(0, times = mc_num)
beta1 <- rep(0, times = mc_num)
sigma2 <- rep(0, times = mc_num)
###############
# Initial Values
###############
sigma2[1] <- 1.00
###########################
# Metropolis Settings
###########################
accept_phi <- rep(1, times = n)
metrop_var_phi <- 0.50
accept_beta0 <- 1
metrop_var_beta0 <- 0.005
accept_beta1 <- 1
metrop_var_beta1 <- 0.005
###################
# Main Sampling Loop
###################
for (i in 2:mc_num) {
    #################################################################
    # Update phi
    #################################################################
    for (j in 1:n) {
        phi_proposed <- rnorm(n = 1, mean = phi[j], sd = sqrt(metrop_var_phi))
        ratio <- exp(log_h_phi(phi_proposed, j) - log_h_phi(phi[j], j))
        if (ratio >= runif(n = 1, min = 0, max = 1)) {
            phi[j] <- phi_proposed
            accept_phi[j] <- accept_phi[j] + 1
        }
    }
    ######################################################################
    # Update beta0
    ######################################################################
    beta0_proposed <- rnorm(n = 1, mean = beta0[i - 1], sd = sqrt(metrop_var_beta0))
    beta0[i] <- beta0[i - 1]
    ratio <- exp(log_h_beta0(beta0_proposed) - log_h_beta0(beta0[i - 1]))
    if (ratio >= runif(n = 1, min = 0, max = 1)) {
        beta0[i] <- beta0_proposed
        accept_beta0 <- accept_beta0 + 1
    }
    ######################################################################
    # Update beta1
    ######################################################################
    beta1_proposed <- rnorm(n = 1, mean = beta1[i - 1], sd = sqrt(metrop_var_beta1))
    beta1[i] <- beta1[i - 1]
    ratio <- exp(log_h_beta1(beta1_proposed) - log_h_beta1(beta1[i - 1]))
    if (ratio >= runif(n = 1, min = 0, max = 1)) {
        beta1[i] <- beta1_proposed
        accept_beta1 <- accept_beta1 + 1
    }
    ################################
    # Update sigma2
    ################################
    a_new <- (n / 2) + a
    b_new <- (sum(phi^2) / 2) + b
    sigma2[i] <- 1 / rgamma(
        n = 1,
        shape = a_new,
        rate = b_new
    )
    #####################################################################
    # Printing to the Log
    #####################################################################
    print(c("Minimum phi Acceptance Rate:", round(min(accept_phi / i), 2)))
    print(c("Maximum phi Acceptance Rate:", round(max(accept_phi / i), 2)))
    print(c("beta0 Acceptance Rate", round(accept_beta0 / i, 2)))
    print(c("beta1 Acceptance Rate", round(accept_beta1 / i, 2)))
    print(c("Completion %:", round(100 * i / mc_num, 2)))
}
#########################################
# MCMC Diagnostics
#########################################
burnin <- 10000
thin <- 10
keep_set <- seq((burnin + 1), mc_num, thin)
effectiveSize(beta0[keep_set])
effectiveSize(beta1[keep_set])
effectiveSize(sigma2[keep_set])
geweke.diag(beta0[keep_set])
geweke.diag(beta1[keep_set])
geweke.diag(sigma2[keep_set])
par(mfrow = c(3, 2))
plot(beta0[keep_set], type = "l")
acf(beta0[keep_set])
plot(beta1[keep_set], type = "l")
acf(beta1[keep_set])
plot(sigma2[keep_set], type = "l")
acf(sigma2[keep_set])
###################################################################################
##########################
# Inference
###################################################################################
##########################
round(c(mean(beta0[keep_set]), sd(beta0[keep_set]), quantile(
    beta0[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
round(c(mean(beta1[keep_set]), sd(beta1[keep_set]), quantile(
    beta1[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
round(c(mean(sigma2[keep_set]), sd(sigma2[keep_set]), quantile(
    sigma2[keep_set],
    c(0.025, 0.500, 0.975)
)), 2)
