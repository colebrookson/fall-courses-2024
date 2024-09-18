################################################################################
# EMD 538 Quantitative Methods for Infectious Disease Epidemiology (FALL 2020) #
#                                                                              #
#          Lab: 2 (Chain binomial models and maximum likelihood estimation)    #
#         Date: Friday, September 13, 2024                                     #
#    Coded by: Shioda, Phillips, Zheng & Jiye Kwon                             #
################################################################################

#------------------------------------------------------------------------------#
# Set up -- Input the Greenwood data (1931)
# Create a table that looks like Table I in Greenwood's paper
# (See Slide 21 in Lecture 2)
#------------------------------------------------------------------------------#

# Number of contacts ranges 1 to 10
contacts <- 1:10

# Number of contacts infected ranges 0 to 7
infect <- 0:7

# Number of households observed in which "infect"=i (rows) out of "contacts"=m
# (columns) members were infected
infect.freq <- matrix(c(
  340, 197, 84, 60, 25, 11, 3, 2, 1, 0,
  164, 104, 60, 29, 15,  6, 4, 2, 0, 0,
    0,  57, 57, 25,  9,  4, 0, 3, 0, 1,
    0,   0, 27, 11, 10,  3, 3, 3, 0, 0,
    0,   0,  0,  7,  1,  0, 2, 0, 0, 0,
    0,   0,  0,  0,  1,  1, 3, 0, 0, 0,
  rep(0,5), 1, rep(0,4),
  rep(0, 6), 1, 1, 0, 0
  ),nrow=8, byrow=T)


#------------------------------------------------------------------------------#
# Let's get familiar with the data (and R) before working on the questions...
#------------------------------------------------------------------------------#

# Table looks like this:
infect.freq

# How many household has 3 contacts (m=3)
sum(infect.freq[,3])
84 + 60 + 57 + 27 # should be same

# We can calculate the total number of households of each size "contacts"=m by
# summing down the rows of "infect_freq"
hhs <- apply(infect.freq, 2, sum) # '2' is column
hhs
# or
colSums(infect.freq)
# or
hhs_ver2 <- c()
for (i in 1:10) {
  hhs_ver2[i] <- sum(infect.freq[,i])
}
hhs_ver2

# Check that hhs and hhs_ver2 are identical
hhs == hhs_ver2
which(hhs != hhs_ver2) # None

# We can calculate the total number of households in which "infect"=i people
# were infected by summing across the columns
tot.freq <- apply(infect.freq, 1, sum) # '1' is row
# or
rowSums(infect.freq)
# or
tot.freq_ver2 <- c()
for (i in 1:nrow(infect.freq)) {
  tot.freq_ver2[i] <- sum(infect.freq[i,])
}
tot.freq_ver2

# Check that tot.freq and tot.freq_ver2 are identical
tot.freq == tot.freq_ver2
which(tot.freq != tot.freq_ver2) # None


#------------------------------------------------------------------------------#
# 1. What is the total number of households with m=3 contacts?
#
# NOTE: You will be dong the same thing for HHs w 4 contacts in Problem Set 1
#------------------------------------------------------------------------------#

84 + 60 + 57 + 27

h3 <- sum(infect.freq[,3])


#------------------------------------------------------------------------------#
# 2. First, assume there is NO on-going transmission in households. Estimate p
#    from the secondary attack rate (SAR) among ALL households (assuming that
#    everyone who was infected had symptom onset within the maximum serial
#    interval).
#------------------------------------------------------------------------------#

# What is an equation for SAR?

# What does "on-going transmission" mean?
# People who escaped infection by the index case will also escape infection by secondary cases
# Or, in other words, secondary cases are all attributed to the same index case

# Numerator of SAR (How many individuals were infected?)
723*0 + 384*1 + 156*2 + 57*3 + 10*4 + 5*5 + 1*6 + 2*7 # or
sum(infect*tot.freq)

# Denominator of SAR (How many individuals were at risk (susceptible)?)
504*1 + 358*2 + 228*3 + 132*4 + 61*5 + 26*6 + 16*7 + 11*8 + 9*1 + 10*1 # or
sum(contacts*hhs)

# Thus, an estimated SAR is:
952 / 3112 # or
p.est <- sum(infect*tot.freq) / sum(contacts*hhs)
p.est

# Or, you can use %*% to multiply two vectors (1xN)*(Nx1)=(1,1) i.e. scalar
p.est_ver2 <- (infect%*%tot.freq)/(contacts%*%hhs)
p.est_ver2

# Biggest assumption: everyone got infected by the index case

# Extra question:
# How about the SAR for HHs w 3 people?
(84*0+60*1+57*2+27*3)/(228*3)
infect.freq[,3]
infect
infect*infect.freq[,3]
sum(infect*infect.freq[,3]) / sum(infect.freq[,3]*3)


#------------------------------------------------------------------------------#
# 3. Calculate the expected frequency of secondary infections (for m=3) given
#    NO on-going transmission
#------------------------------------------------------------------------------#

# HINT: Use dbinom

# Let's start with an easier question.

# Probability of observing zero secondary infections:
dbinom(0, 3, p.est) # or
n <- 3
x <- 0
dbinom(x, n, p.est) #or
choose(n,x)*(p.est^x)*(1-p.est)^(n-x)
# Therefore, we expect to see the following number of households with zero
# secondary infections
dbinom(0, 3, p.est) * h3 # = Prob * number of HHs

# Probability of observing one secondary infection:
dbinom(1, 3, p.est)
# we expect to see the following number of households with one
# secondary infections
dbinom(1, 3, p.est) * h3 # = Prob * number of HHs

# Do the same thing for 2, and 3 secondary infections.
dbinom(2, 3, p.est)
dbinom(2, 3, p.est) * h3

dbinom(3, 3, p.est)
dbinom(3, 3, p.est) * h3

# Or, we can also do it all together as follows:
E.freq <- h3 * dbinom(0:3, 3, p.est)
E.freq

##### Now let's estimate p and q for the chain binomial model #####

#------------------------------------------------------------------------------#
# 4. Calculate the observed mean number of infected contacts for m=3
#    (per household)
#
#    (On average, how many people were infected by the index case in HHs w
#     3 people?)
#------------------------------------------------------------------------------#

(84*0+60*1 + 57*2 + 27*3) / 228

# Observed mean number
O.mean <- sum(infect*infect.freq[,3]) / h3


#------------------------------------------------------------------------------#
# 5. Use optimization to solve for the expected number of contacts
#    (by minimizing the squared error)
#------------------------------------------------------------------------------#

# We want to find a probability that can reproduce the observed mean
# (O.mean = 1.118421)

# Why do we need to take a square?

# We can use optimization to solve for the expected number of contacts by
# minimizing the squared error

# To do this we first define a function to evaluate squared error at set values
# of 'q'

sqerror <- function(q){
  return((3 - 3*q^2 + 3*q^3 - 15*q^4 + 18*q^5 - 6*q^6 - O.mean)^2)
}

# Examples...
sqerror(0.5) # Squared error at q=0.5
sqerror(0.6)
sqerror(0.7)
sqerror(0.8)

# Which one had the smallest squared error?

# Then we will input the function to be minimized into optim() and set an
# "arbitrary" initial value
?optim # This is the function that you will be using a lot in this course
optim(par=0.5, fn=sqerror) # Warning message

# Another function for optimization
?optimize
optimize(f=sqerror, interval=c(0,1))
optimize(f=sqerror, interval=c(0,1))$minimum
sqerror(optimize(f=sqerror, interval=c(0,1))$minimum) # Squared error is very small


#------------------------------------------------------------------------------#
# 6. Assign the value of “q” that is a REAL number between 0 and 1 and
#    calculate “p”.
#------------------------------------------------------------------------------#

q <- optimize(f=sqerror, interval=c(0,1))$minimum
p <- 1-q


#------------------------------------------------------------------------------#
# 7. Calculate the probability of each possible chain, using Greenwood's
#    assumption
#------------------------------------------------------------------------------#


p.chainGW <- c(q^3, # <---------------------------------- 0 infected
               3*p*q^4, # <------------------------------ 1 infected
               6*p^2*q^4, 3*p^2*q^2, # <----------------- 2 infected
               p^3, 6*p^3*q^3, 3*p^3*q, 3*p^3*q^2) # <--- 3 infected
p.chainGW
sum(p.chainGW) # Should be one


#------------------------------------------------------------------------------#
# 8. Calculate the probability of each possible number of secondary infections,
#    using Greenwood assumption.
#------------------------------------------------------------------------------#

p.infectGW <- c(p.chainGW[1], # 0 infected
                p.chainGW[2], # 1 infected
                sum(p.chainGW[3:4]), # 2 Infected
                sum(p.chainGW[5:length(p.chainGW)])) # 3 infected
p.infectGW
sum(p.infectGW)


#------------------------------------------------------------------------------#
# 9. Calculate the expected distribution of secondary infections, using
#    Greenwood assumption.
#------------------------------------------------------------------------------#

E.infectGW <- h3 * p.infectGW # See Slide 35 in Lecture 2
E.infectGW


#------------------------------------------------------------------------------#
# 10. What if we follow the Reed-Frost assumption instead of the Greenwood
#     assumption? Re-calculate the probability of each chain (using the same
#     values of p and q)
#------------------------------------------------------------------------------#

# Probability of each chain (under RF assumption)
p.chainRF <- c(q^3,  # <----------------------------------------- 0 infected
               3*p*q^4, # <-------------------------------------- 1 infected
               6*p^2*q^4, 3*p^2*q^3, # <------------------------- 2 infected
               p^3, 6*p^3*q^3, 3*p^2*q*(1-q^2), 3*p^3*q^2) # <--- 3 infected

# Probability of each number of infections (under RF assumption)
p.infectRF <- c(p.chainRF[1], # 0 infected
                p.chainRF[2], # 1 infected
                sum(p.chainRF[3:4]), # 2 infected
                sum(p.chainRF[5:length(p.chainRF)])) # 3 infected

# Expected distribution of secondary infections (under RF assumption)
E.infectRF <- h3 * p.infectRF
E.infectRF # Which one looks closer to what was observed? Greenwood or RF?


#------------------------------------------------------------------------------#
# Now let's relax our assumptions and estimate separate values for q1 and q2.
# We can make an initial "guess" at what the values of q1 and q2 are.
# (see Becker (1989) p. 18)
#------------------------------------------------------------------------------#

# What are q1 and q2?
# q1 is the probability of escaping infection from one infector.
# q2 is the probability of escaping infection when there are two possible infectors

# theta is the probability of j contacts ultimately being infected
# (= the sum of the probabilities of the various chains that lead to j infections)
# (See slide 52 in Lecture 2)
theta <- infect.freq[,3]/h3

q1.guess <- theta[1]^(1/3)
p1.guess <- 1 - q1.guess
q2.guess <- theta[3]/(3*q1.guess*p1.guess^2) - 2*theta[1] #


#------------------------------------------------------------------------------#
# Refresher: probability vs likelihood
#     
#------------------------------------------------------------------------------#

# Given: 8 heads after 10 flips 
# Probability: what is the probability of that outcome given p=0.5

dbinom(8,10,0.5)
plot(dbinom(8,10,seq(0.01,0.99,by=0.01)))

# Given: 8 heads after 10 flips 
# Likelihood: what is the likelihood that it is a fair coin (i.e. p=0.5) 
# given the outcome we observed.
thetas <- seq(0, 1, .01)
plot(thetas, dbinom(8,10,thetas), type="l", main="Likelihood")

# trying to optimize the likelihood of theta | X 
# theta = p; likelihood that it is a fair coin (i.e. p=0.5) 
# X = 8 heads after 10 flips; given the outcome we observed.
# negative binomial distribution 
example = function(p){-dbinom(8,10,p)}
optim(0.5,example)$par #0.8

# negative log-likelihood 
# because R minimizes not maximizes 
# we talk about maximizing log likelihood 
logexample = function(p){-log(dbinom(8,10,p))}
optim(0.5,logexample)$par

#------------------------------------------------------------------------------#
# 11. Calculate the value of the negative log-likelihood at our initial
#     "guesses" for q1 and q2.
#------------------------------------------------------------------------------#

# First, use the "function" file that I created called 'chainbinolikl3' to
# calculate the negative log-likelihood.

setwd("/Users/yc954/Desktop/Yale/TF/EMD538/Lab02") # <--- Change this!
# recreates second line of side 52 (loglikl)
source('chainbinolikl3.R')  

obs <- infect.freq[,3]
chainbinolikl3(q=c(q1.guess, q2.guess))


#------------------------------------------------------------------------------#
# 12. Compare this to the negative log-likelhood for q1=q2=0.5.
#------------------------------------------------------------------------------#

chainbinolikl3(q=c(0.5,0.5))
chainbinolikl3(q=c(0.75,0.5))


#------------------------------------------------------------------------------#
# 13. Now we will solve for for q1 and q2 by minimizing the value of the
#     function using optim
#------------------------------------------------------------------------------#

optim(par=c(q1.guess, q2.guess),chainbinolikl3) # $par 

#what happens if you have a random guess?
optim(par=c(0.5,0.5),chainbinolikl3)

q.est <- optim(par=c(0.5,0.5),chainbinolikl3)$par
p.est <- 1-q.est


#------------------------------------------------------------------------------#
# 14. What is the value of the negative log-likelihood at our best-fit estimate?
#------------------------------------------------------------------------------#

chainbinolikl3(q=q.est) # or
optim(par=c(0.5,0.5),chainbinolikl3)$value


