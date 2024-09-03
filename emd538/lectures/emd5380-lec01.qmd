---
title: EMD 538 - Lecture 01
date: 2024-08-28
format:
   pdf: 
     toc: true
---

# Probability Distributions 

- Discrete versus continuous etc 
- PDF vs CDF 
    - PDFs (for discrete it's a mass function) and is the probability that the variable $X$ takes on exactly some value $x$
        - goes to 0 as $x$ -> $\infty$
    - CDF is the probability that the random variable $X$ is less than or equal to some value $x$ 
        - goes to 1 as $x$ -> $\infty$
    -  the integral of the PDF gives us the CDF
    - Notation:
        $$F(x) = \int_{-\infty}^{x} f(u) du$$

## Discrete Probability Distributions 

- Bernoulli 
- Binomial 
- Multinomial 
    - probability of exactly $x_i$ outcomes of type $i$ in $n$ independent trials, where $p_i$ is the probability of success in a single trial of type $i$
    - *this is a generalization of the bernoulli distribution for more than 2 possible outcomes*
- Geometric 
- Negative Binomial 
- Poisson 

## Normal Distribution 

- Normal (Gaussian)
- Exponential 
    - distribution of time between events occuring independently at a constant rate $\lambda$
- Gamma 
    - distribution of time required for exactly $r$ events to occur assuming events take place at a constant rate $\lambda$ (generalization of the exponential). 
