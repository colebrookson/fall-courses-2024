################################################################################
# EMD 538 Quantitative Methods for Infectious Disease Epidemiology (FALL 2021) #
#                                                                              #
#          Lab: 4 (Analysis of outbreak data, Part II)                         #
#         Date: Friday, September 25, 2024                                     #
#  Coded by: Shioda, Phillips, Jiye Kwon & Yi Ting                             #
################################################################################

# set.seed(123)
#------------------------------------------------------------------------------#
# When developing and applying new methods (as in Lipsitch et al (2003) and 
# Wallinga & Teunis (2004)), it is common to test out your method by simulating 
# data and then analyzing it, such that you know what the answer should be and 
# can compare to the answer that you get using your method. 
# 
# For example, let’s simulate an epidemic with R0 = 3 for an infection with a 
# mean latent period of 2 days and a mean infectious period of 6 days beginning 
# with one infectious individual.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# 1. Use the function in the file “stochseir” to simulate an epidemic, first 
#    assuming fixed latent and infectious periods.
#------------------------------------------------------------------------------#

# Load function stochseir()
setwd("/Users/yc954/Desktop/Yale/TF/EMD538/Lab04") # <--- Change it to your location
source(file="EMD538_2023_Lab4_stochseir.R")

# Simulate SEIR model

# Run the following function many times
stochseir(fixed=1) 
# NOTE: set =1 for fixed latent/infectious period
#           =0 for exponentially distributed

# Make an epi curve
plot(stochseir(1), col='red', type='l', lwd=2, xlab="Days", ylab="Number of cases")

# R0 > 1 doesn’t guarantee an epidemic will occur

#------------------------------------------------------------------------------#
# 2. Use a “for loop” to run “stochseir” 20 times, saving the total number of 
#    cases as “TotCaseF” each time.  What is the probability of a large epidemic 
#    (>50 cases)?
#------------------------------------------------------------------------------#

# Create an empty vector to save the total number of cases 
TotCaseF <- rep(NA,20)

# Create a for loop to run "stochseir" 20 times 
for (i in 1:20) {
  TotCaseF[i] <- sum(stochseir(1))
}
TotCaseF

# Find the proportion of outbreaks with >50 cases (Version 1)
over50 <- ifelse(TotCaseF > 50 ,1, 0) # 1 if >50; 0 otherwise
over50

# Find the proportion of outbreaks with >50 cases (Version 2)
sum(over50)/length(over50) 
# or
mean(TotCaseF > 50)


#------------------------------------------------------------------------------#
# Now let's assume exponentially distributed latent and infectious periods.
# 
# 3. Again, use a “for loop” to run “stochseir” 20 times, saving the total 
#    number of cases as “TotCaseE” each time.  Now what is the probability of a 
#    large epidemic (>50 cases)?  Is it greater or less than you got in #1?
#------------------------------------------------------------------------------#

# Create an empty vector to save the total number of cases 
TotCaseE <- rep(NA,20)

# For loop to run "stochseir" 20 times 
for (i in 1:20) {
  TotCaseE[i] <- sum(stochseir(fixed=0)) # =0 for exponentially distributed latent/infectious period 
}
TotCaseE

# Find the proportion of outbreaks with >50 cases
mean(TotCaseE > 50)

# It is smaller than what we got in Q1. 

# Why? 


#------------------------------------------------------------------------------#
# Now run “stochseir” until you get a large epidemic.
#------------------------------------------------------------------------------#

NewCases <- stochseir(fixed=0)
plot(NewCases, col='red', type='l', lwd=2, xlab="Days", ylab="Number of cases") 


#------------------------------------------------------------------------------#
# 4. Calculate the cumulative number of cases up to time t for t = 1 to 30 days.
#------------------------------------------------------------------------------#

# Why 30 days? 

# Version 1
CumCasesE <- cumsum(NewCases[1:30])

# Make a plot
plot(CumCasesE, type="o", bty="l", pch=16, 
     ylab="Cumulative number of cases", xlab="Days")


#------------------------------------------------------------------------------#
# 5. Plot the log of the cumulative number of cases vs time and use glm() 
#    function to fit a linear regression. What is the slope of this line?
#------------------------------------------------------------------------------#

# Practice: take the natural log
log(2)
log(exp(2)) #e^(x) is the inverse of ln(x)

# How can we take a log of the cumulative number of cases?
log(CumCasesE)

# Make a plot: the log of the cumulative number of cases vs time
plot(log(CumCasesE), type='o', pch=16, col='red', bty="l",
     xlab="Days", ylab="Log(Cumulative number of cases)")

### Fit a linear regression

# Create a variable, t (time)
t <- 1:30

# Fit a linear regression to the log of the cumulative number of cases 
mod1 <- glm(log(CumCasesE) ~ t) # glm(y ~ x) -- can also use lm(log(CumCasesE) ~ t)

# Result of the linear regression model
summary(mod1)

# Plot a linear line
lines(mod1$fitted.values, col='blue', lwd=2)

# Optional (plot in the original scale): 
plot(CumCasesE, type='o', col='red', pch=16,
     xlab="Days", ylab="Cumulative number of cases")
lines(exp(mod1$fitted.values), col='blue', lwd=2)


# Store our estimated slope 
mod1$coefficients # Estimated coefficients
r1 <- mod1$coefficients[2] # Second element is the slope
r1 # <--- This is the growth rate!

# NOTE: Can store not only coefficients but also other values
names(mod1)


#------------------------------------------------------------------------------#
# 6. Calculate the value of R0 for the epidemic using the growth rate “r” you 
#    calculated in #4 and the equation from Lipsitch et al (2003):
# 
#        (Equation)
# 
#    where V is the serial interval and f is the ratio of the latent period to 
#    the serial interval.
#------------------------------------------------------------------------------#

# How did we derive this equation in Lipsitch et al (2003)? 
# --> You will find that in Problem Set 2

# Let's set f and v
f <-   2/8   # ratio of the latent period to the serial interval
v <-   8     # duration of the serial interval

# The equation from Lipsitch et al (2003) is:
R0 <- (r1^2)*(1-f)*f*(v^2) + r1*v + 1
R0 # Something around 3 (e.g., 3.2), which is consistent with our initial 
# setting (R0 = beta1/gamma = 3)


#------------------------------------------------------------------------------#
# 7. Use glm() with a “Poisson” link to calculate the growth rate over the 
#    first 25 days of the epidemic, and recalculate R0 using the equation in #6.  
#    How does these values compare to each other and to the “true” value of 
#    R0 = 3?  
#------------------------------------------------------------------------------#

# Fit a Poisson regression to the log of the cumulative number of cases 
t <- 1:25
CumCasesE <- CumCasesE[1:25]
mod2 <- glm(CumCasesE ~ t, family=poisson) # The default link of poisson is log link

# Result of the linear regression model
summary(mod2)

# Make a plot (log scale)
plot(log(CumCasesE), type='o', col='red', bty="l", pch=16,
     xlab="Days", ylab="Log(Cumulative number of cases)")
lines(log(mod2$fitted.values), col='blue', lwd=2)
# Make a plot (original scale)
plot(CumCasesE, type='o', col='red', bty="l", pch=16,
     xlab="Days", ylab="Cumulative number of cases")
lines(mod2$fitted.values, col='blue', lwd=2)

# Extract the growth rate, r
r2 <- mod2$coefficients[2] 
r2 # E.g., 0.1604156. It is very close but smaller than the previous 'r' 

# Calculate R0
R0 <- (r2^2)*(1-f)*f*(v^2) + r2*v + 1
R0 # E.g., 2.991739 Smaller than the one in Q6. 

#------------------------------------------------------------------------------#
# Now suppose you observed the following serial interval distribution among 
# 85 secondary cases:
#
# 8. Create a 85 x 1 vector “obsV” which is the observed serial intervals for 
#    all 85 secondary cases.
#------------------------------------------------------------------------------#

# Make a vector
obsV <- c(rep(2,10),rep(4,20),rep(5,16),rep(6,8),rep(7,10),
          rep(8,8),rep(9,5),rep(10,5),rep(12,3))
obsV

# Make a histogram
hist(obsV, col="grey",  breaks = 14, include.lowest = TRUE)
abline(v=mean(obsV), col="red", lty=2, lwd=2)


#------------------------------------------------------------------------------#
# 9. Fit a gamma distribution to the observed serial interval distribution.
#------------------------------------------------------------------------------#

### ------- Review ------- ###

# What is the gamma distribution?

# A generalization of the exponential distribution, for r independent events instead of 1.

my_rate <- 0.5
my_x <- 1:20

d_gamma <- dgamma(my_x,shape=1,rate=my_rate)
d_expon <- dexp(my_x,rate=my_rate)
plot(my_x,d_gamma,type='o',col='red')
lines(my_x,d_expon,type='o',col='blue',lty=2)

# How does "shape" change gamma pdf?
par(mfrow=c(2,2)) # Divide R plotting device into 2 rows, 2 columns

plot(dgamma(my_x,shape=1, rate=0.5), type="o", pch=16, col="red", lwd=2,
     main = "shape =1, rate = 0.5")
plot(dgamma(my_x,shape=2, rate=0.5), type="o", pch=16, col="red", lwd=2,
     main = "shape =2, rate = 0.5")
plot(dgamma(my_x,shape=3, rate=0.5), type="o", pch=16, col="red", lwd=2,
     main = "shape =3, rate = 0.5")
plot(dgamma(my_x,shape=6, rate=0.5), type="o", pch=16, col="red", lwd=2,
     main = "shape =6, rate = 0.5")

dev.off() # Turn 'off' the plotting device division done by par(mfrow())


# Ok, now let's go back to the question.-------------------------------------

# We want to find "shape" and "rate" that maximizes log-likelihood (or minimizes
# negative loglikelihood) --> optim()

# Create a function that calculates negative log-likelihood for each value of 
# shape and rate
nLLgamma <- function(pars){
  shape <- pars[1]
  rate  <- pars[2]
  return(-sum(dgamma(obsV, shape, rate, log=T)))
}

# Find optimal values for shape and rate
optim(c(1,1), nLLgamma)
# NOTE: our initial guess is shape=1 and rate=1. You can change it.
# nLLgamma is the name of the function that we want to minimize.

# Store results in a vector
gpars <- optim(c(1,1), nLLgamma)$par
gpars # shape=5.09  rate=0.877


# R has an efficient function to do so for gamma distribution! 
library(MASS) # Load this library: MASS
gpars <- fitdistr(obsV, densfun = 'gamma', start=list('shape'=1,'rate'=1))[[1]]
gpars
# This way, we don't have to create nLLgamma 


#------------------------------------------------------------------------------#
# 10. What is the probability “g” of observing serial intervals of 1 to 15 days?
#------------------------------------------------------------------------------#

g <- dgamma(1:15, shape=gpars[1], rate=gpars[2]) # gamma PDF
g

#------------------------------------------------------------------------------#
# 11. Plot a histogram of the observed serial intervals and the best-fit gamma 
#     distribution
#------------------------------------------------------------------------------#

# Histogram of the observed serial intervals
hist(obsV, xlim=c(0,15), col='grey')

# First, calculate density for x = 1, 0.01, 0.02, ... , 14.99, 15.00
g <- dgamma(seq(0, 15, by=0.01), shape=gpars[1], rate=gpars[2])

# Add the best-fit gamma distribution
par(new=T) # Add overlying plot 
plot(y=g, x=seq(0, 15, by=0.01), 
     xlim=c(0,15), axes=F, ann=F, type='l', lwd=3, col='red')


#------------------------------------------------------------------------------#
# 12. Calculate the probability p_ij of any given case i with symptom onset on 
#     day ti being infected by a case j occurring on day tj for the first 25 
#     days of the epidemic.
# 
#     Or rather, assume that the epidemic ended on Day 25. In your simulation,
#     you may have cases after Day 25, but from here, let's just assume that 
#     your outbreak ended on Day 25. (Original version of Wallinga & Teunis 
#     method requires data for complete epidemic)
#------------------------------------------------------------------------------#

# i is row ("resultor" or "infectee")
# j is column ("infector")

### ------- Example in Slide 43 - 47 ------- ###

G <- c(0.25, 0.5, 0.25) # Serial interval distribution
p <- matrix(NA, nrow=6, ncol=6) 
Example_NewCases <- c(1, 1, 4, 6, 6, 9) # Number of cases on Day 1, 2, 3, ... 6
# Let's calculate p[i,j]
# Case on Day 2 (Slide 44)
p[2,1] <- G[2-1] / (G[2-1]*Example_NewCases[1])  # p[2,1] is the prob that a case on Day 2 was infected by a case on Day 1
# Case on Day 3 (Slide 45)
p[3,1] <- G[3-1] / (G[3-1]*Example_NewCases[1] + G[3-2]*Example_NewCases[2])  
# p[3,1] is the prob that a case on Day 3 was infected by a case on Day 1
p[3,2] <- G[3-2] / (G[3-1]*Example_NewCases[1] + G[3-2]*Example_NewCases[2]) 
# Case on Day 4 (Slide 46)
p[4,1] <- G[4-1] / (G[4-1]*Example_NewCases[1] + G[4-2]*Example_NewCases[2] + G[4-3]*Example_NewCases[3]) 
p[4,2] <- G[4-2] / (G[4-1]*Example_NewCases[1] + G[4-2]*Example_NewCases[2] + G[4-3]*Example_NewCases[3]) 
p[4,3] <- G[4-3] / (G[4-1]*Example_NewCases[1] + G[4-2]*Example_NewCases[2] + G[4-3]*Example_NewCases[3]) 
p
# Keep going...

# Obviously it's not practical to do it manually for the entire epidemic. So we
# can use a "for" loop to do it repeatedly go through the i's and j's
#------------------------------------------------------------------------------#
# Ok, let's go back to the question.
# First 25 days of the epidemic
plot(NewCases[1:25], type = 'o', col="red", lwd=2, pch=16, bty="l",
     ylab="Number of cases", xlab="Days")

# Probability density of serial interval (1 to 25 days)
g <- dgamma(1:25, shape=gpars[1], rate=gpars[2]) 

# For loop
p <- matrix(0, nrow=25, ncol=25) # Matrix with zeros
View(p)
for (i in 2:25) {
  if (NewCases[i]>0) {      # If there are new cases on day i...
    for (j in 1:(i-1)) {    # Consider all potential infectors on days 1 to (i-1)
      if (NewCases[j]>0) {
        # Calculate p[i,j] which if the probability that a case on Day i was infected by a case on Day j
        p[i,j] = g[i-j]/(g[seq(i-1,1,-1)] %*% NewCases[1:(i-1)])
      }
    }
  }
}

# Let's see how it looks like
View(p)
View(round(p, digit=2))

# Example:
# Probability of any given case i with symptom onset on day ti being infected 
# by a case j occurring on day 7
plot(p[,7],type='o',col="blue",lwd=2,bty="l",pch=16,
     xlab="Day ti",ylab="Prob that cases ")
# p[,7] should be zero from Day 1 to 7, because cases on Day 7 cannot infect
# cases occurring on Day 7 or before.
# NOTE: If you see a flat line in a plot, that probably means that your outbreak
#       did not have any cases on Day 7. Change 7 to something else and try again.


#------------------------------------------------------------------------------#
# 13. Calculate Rj for cases occurring during the first j = 1 to 25 days of the 
#     epidemic.  How does the mean value compare to the value of R0 you 
#     calculated above?
#------------------------------------------------------------------------------#

# Similar to what we did in Slide 50 in Lecture 2

R0 #value we will compare Rj to

Rj <- rep(NA, 25)
for (t in 1:25) {
  Rj[t] <- p[t:25,t] %*% NewCases[t:25]
}
Rj

# What is the (nonzero) mean?
mean(Rj[Rj>0])

# Make a plot of Rj
plot(Rj, type='h', col="blue", lwd=5)
abline(h=1,col='red', lty=2) # R0=1
abline(h=mean(Rj[Rj>0]),col='orange') # Mean

# How does the mean value compare to the value of R0 you calculated above?

# Why is Rj = 0 on Day 25?




#------------------------------------------------------------------------------#
# For PSET 2
#------------------------------------------------------------------------------#

# How to load a .mat file 

#you will need to install the package "R.matlab
# install.packages("R.matlab")
library(R.matlab)

setwd("~/Desktop/EMD538/Problem_Sets")

# load data
covidCT <- readMat('covidCT.mat')
#loads as a list, not a dataframe

# look at names of all elements
names(covidCT)

# access each "variable"
covidCT$dateCT     #matrix
covidCT$newcasesCT #vector
covidCT$serint     #vector

#you can attach the dataset if you don't want to use "covidCT$..." each time
attach(covidCT)
dateCT

#just make sure that if you attach it, you detach it when you are done!
