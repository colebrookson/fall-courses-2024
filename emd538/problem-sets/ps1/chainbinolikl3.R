chainbinolikl3 = function(q){
  #INPUTS: q = probability of escaping infection
  #obs = number of households in which 0, 1, 2, or 3 members were infected (="n" in lecture notes)
  #OUTPUT: nLL = negative log-likelihood of model given data
  
  p = 1-q
  
  p.chain = c(q[1]^3, 3*p[1]*q[1]^4, 6*p[1]^2*q[1]^4, 3*p[1]^2*q[1]*q[2], p[1]^3, 6*p[1]^3*q[1]^3, 3*p[1]^2*q[1]*p[2], 3*p[1]^3*q[1]^2) 
  #Probability of each chain
  p.infect = c(p.chain[1], p.chain[2], sum(p.chain[3:4]), sum(p.chain[5:length(p.chain)])) 
  
  # Probability of 0, 1, 2, or all 3 hh members infected (="theta" in lecture notes page 50)
  
  obs=obs[1:length(p.infect)] ## Make sure the observed data is the same size as p_infect 
  #(i.e. discard the 0s corresponding to >3 people infected)
  
  # We can now calculate the log-likelihood in one of two ways...
  
  # (1) We could use a "for" loop to calculate n(j)*log(theta(j)) over the all
  # possible values of j (=0 to 3, i.e. the number of contacts infected),
  # then take the negative sum...
  
  loglikl = c()
  for (j in 1:length(p.infect)){
    loglikl[j] = obs[j]*log(p.infect[j]) # Log-likelihood for each value of j
  }
  nLL = -sum(loglikl)
  
  ### (2) Or we could use vector multiplication to do this for us...
  #
  #nLL=-(obs%*%log(p.infect))
  #
  ## Note: We can ignore the constant ("C") in the log-likelihood, since this
  ## just moves the log-likelihood up or down by some amount.  It doesn't
  ##         affect the values of q for which the max/min occurs!
  return(nLL)
}
