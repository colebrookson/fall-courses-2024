---
title: EMD 538 - Lecture 02
date: 2024-09-04
format:
   pdf: 
     toc: true
---

# Importance of infectious diseases 

Infectious disease: "illness due to specific infectious agent (pathogen) or it's products that arises through transmission of that agent from an infected person, animal, reservoir or vector..."

## Modes of Transmission

- direct transmission 
    - MMR, TB, flu, STIs 
- vector-borne transmission
    - passes from person to person via an athropod vector 
- indirect transmission 
    - contaminated water or sewage (e.g. cholera, typhoid, etc.)
- zoonoses 
    - transmitted directly  or through some host, or you can get it from something like food and then pass it on
    - the pathogen is maintained in the "animal" species, and then you may have transmission from humans to other humans, but it's generally maintained in the wildlife reservoir 
- environmental pathogens 
    - harboured in the environment and then will pass on the disease (includes tetanus and botulism) 

## Differences of infectious diseases

- cases can be the source of infection 
    - there's a simple model of this infection process $y_i = \beta_0 + \beta_1 x_{1,i} + ... + \beta_n x_{n,i}$, or you could do the same thing for a logistic regression $log ( \frac{p_i}{1-p_i} )$, and also a cox proportional hazard model $log(\lambda_i(t))$
    - the basic assumption that underlies all these models is that the outcome of an individual in this population is independent
    - pathogen exposure is the ultimate effect modifier - even if you have lots of risk factors, if you're never exposed you're not going to get the disease 
    - Dealing with non-independence 
        - ignore them (sometimest this is fine)
        - condition on exposure 
        - design studies and analyses to account for transmission (focus of this course)

- cases can be sources without being recognized (e.g. infection that doesn't cause a lot of disease but then is a source of illness to others)
    - asymptomatic infections are a common state in these system (e.g. strep, staph, etc)
    - diseases are a pretty small amount (often), but the infections that are not reported (asymptomatic) may account for the majority of transmission
    - disease vs etiology: you often get reports of like "pneumonia, diarrhea" etc but you don't actually know what the causes of those are necessarily 
- immunity 
    - example is flu (1911 - 1917 vs 1918)
    - e.g. immune scenence and also just lack of immune system in babies 
    - antibodies provide a record of infection 
- enormous variations in incidence / prevalence 
    - there's often seasonality in diseases 
    - 



