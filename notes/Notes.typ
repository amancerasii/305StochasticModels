#set text(font: "Lato", size: 9.5pt)
#import "@preview/physica:0.9.5": *
#import "@preview/cetz:0.4.2"
#show math.equation: set text(font: "Lete Sans Math")

#set page(
  header: [ Physics 305 Lecture Notes   #h(1fr) Quantum Computation and Information
#line(length: 100%)],footer: context [#line(length: 100%)2014-90687 Manceras, Amancio II S. #h(1fr) Page #counter(page).display("1")],
  columns: 2, margin: (x:0.7in, y:1in))
#set par(justify: true)
#let ans(cont) = block(fill: luma(240), inset: 10pt, radius: 5pt,cont, width: 100%)
#let date(cont) = [ #align(center,block(fill: luma(0),text(size: 8pt,white,weight: "black")[#cont], inset: 4pt, radius: 0pt, width: 101%))]

#date([10 September 2025])

= Paper: Hawkes Models and Their Applications
Laub, Lee, Pollett, Taimre

Keyword
self-exciting point process

Hawk process
$
R(t) = sum_(k, S_(k) < t) Y_k = f({x_(k)},s_(k) < t)
$

Hawkes process - the one arrival creates a heightened chance of further arrivals in the near future.

Two applications: seismology and in finance
- marked forces fed back by the increase and decrease of stocks

#ans([
Stoichiometric process
  $
  X -> 0 "death"\
  0 -> X "birth"
  $

  or
  $
  X -> 2X\
  X -> 0
  $
  like in fission or budding. Or
  $
  2X -> 3X\
  X -> 0
  $
  Or a sexual process
  $
  X + Y -> 2X + Y\
  X + Y -> X + 2Y\
  X -> 0\
  Y -> 0
  $
  There is a package of julia that generates SSA, DE, langevin equation by simple input of the chemical equations. Explore only for birth and death process.

])

Hawkes process - self-excitation, occurrence of one event may trigger a series of similar events.

Explosion of popularity is attributed to financial applications.

Rate of arrivals depend in a particular way on past history.

random variable called ork associated with each arrival.

== Classical Hawkes Process

=== Counting and Point Processes
$
N(t) = sum_(i)^(oo) cal(I) {T_(i) <= t} = sum_(T_(i <= t))1
$

$T_(i)$ jump times are also called arrival times\
$T_(0) = 0$,\
$E_(i) := T_(i) - T_(i-1)$ are called the interarrival times.

homogenous Poisson process has 
$
E_(i) ~ exp( lambda), E(E_(i)) = (1)/( lambda) and E(N_(i)/t)
$

= Conditional Intensity and Compensators

$
 lambda^(*)(t) = lim_(Delta -> 0) E(N_(t+Delta ) - N_(t)|cal(H) _t)/Delta 
$

Poisson process with rate function $ lambda(t)$, homogeneous if $ lambda(t) =  lambda$ does not depend on $t$.

=== Compensator
$
Lambda =  integral_(0)^(t)  lambda_(s)^(*) d s
$

unique predictable process for which $N_(t)- Lambda_(t)$ isa local martingale.

== Hawkes Process and the Self-Exciting Propertiy

=== Hawkes process
a counting process $N_(t)$ whose conditional intensity process for $t >] 0$ is 
$
 lambda^*_t =  lambda + sum_(T_(i)<t) mu(t-T_(i))
$ 

$ lambda >0$ the background arrival rate and $mu$. 

For a special excitation function $mu(t)=  alpha exp(- beta t)$, exponentially decaynig intensity $ lambda_(t)^(*)$.

#ans([punctuated equilibrium])



=== The Immigration-Birth View and Stationarity
Immigrants represents exogenous shocks to the systems

An immigrant arriving at times $s$ creates a new Poisson process of births or offspring with intensity $mu(t-s)$ for $t>s$.

#ans([Transforms:
  The transformation of $delta (t - t_(0))$ is the kerner $K(s; t=t_0)$. The question of transformation is what is the diract delta series that reproduces your time series signal.

  Laplace transforms is usually used in circuits, specially in dissipative systems.
])

Each of this births generates more offspring. Hawkes process can be represented by the chemical equation.

An arrival at time $s$ will generate a Possion$(eta)$ number of first-generation offspring over $t >= s$. This $eta$, called the branching ratio.

the expected number of offspring in all generations is $sum_(k=1)^(oo) eta^(k) = eta / (1 - eta)$ if $eta < 1$. The condition $eta < 1$ is necessary and sufficient for the process to be stationary and have a finite mean.

#ans([Liapunov exponent])

$
lim_(t -> oo) N_(t)/t =  (lambda)/(1 - eta)#h(1em) " almost surely"
$

=== Omori law and Omori-Utus law
an aftershock model. The aftershock rate as approximately

$
K(t+c)^(-1) (K, c >0)
$

modified Omori law
$
mu(t) = K(t + c)^(-p)(p > 1)
$

$mu$ is also called th epower-law kernal since its normalized form $
v(t) = (p-1)/(c) (1 + (t)/(c))^(-p)
$

#date([12 September 2025])
No class next week but activities will be monitored.

= Compartmental Models
fastest way to model the dynamics of a system


State-Based
- usually dynamical state
- condition (color, age, stage, etc)

State $->$ compartment
- magnitude per compartment (e.g. number)
- Causaltive relationships between compartments
  - in the form of graphs between compartments
- parameter identified per motion (e.g. rate)

e.g. SI model

$
 mat(delim: #none,
"susceptible", ,"infectious";
  S, -->, I;
  , beta"SI",;
)
$

$I$ either promotes or inhibits the rate
$S$ also determines the rate and a parameter $ beta$.

for $n_(I)$ infected, the rate will be

$
 beta (n_(I)n_(S))/(N_0)
$

Chemical equation
$
 mat(delim: #none,
,,beta,;
  R_(1):, S+I, -->, 2I
)
$

Stochastic
$
beta : vec(N_(s),N_(I),delim: "[") <- vec(N_(S) - 1, N_(1)+1,delim: "[")
$

ODE

$
dot(n)_(S) = -  beta n_(S) n_(I)\
dot(n)_(I) = +  beta n_(S) n_(I)
$

For a more complicated model, where there is a healing rate

$
 mat(delim: #none,
,,beta, ;
  R_(1), S+I, -->, 2I;
,,gamma, ;
R_(2):, I, --> , S
)
$

Stochastic
$
beta : vec(N_(s),N_(I),delim: "[") <- vec(N_(S) - 1, N_(1)+1,delim: "[")
$
$
gamma : vec(N_(s),N_(I),delim: "[") <- vec(N_(S) + 1, N_(1)-1,delim: "[")
$

ODE
$
dot(n)_(S) = -  beta n_(S) n_(I) + gamma n_(I)\
dot(n)_(I) = +  beta n_(S) n_(I) - gamma n_(I)
$

the number of terms in the ODE is the number of reactions.

SciML: Open Source Software for Scientific Machine Learning
- a Julia language

DifferentialEquations.jl - DE solver

JumpProcesses.jl

== Hawkes Process Reading

=== Excitation Functions and Markov Analysis

Exponentially decaying Hawkes process
$
 lambda^(*)_(t) =  lambda + ( lambda_0 -  lambda)e^(- beta(t-T_(i))),
$

$
 Lambda_(t) =  lambda t + ( lambda_(0) -  lambda)/ beta (1 - e^( -  beta t) ) + sum_(T_(i)< t) ( alpha)/( beta) (1 - e^(- beta(t - T_(i))) 
$

Gamma distribution function is related to the Poisson

==== Likelihood Function
log-likelihood for a Hawkes process
$
l = sum_(i = 1)^( n) log ( lambda + sum_(t_(j)< t_(i))mu (t_(i) - t_(j))) - Lambda_(T)
$

=== Frequentist Inference Techniques

#ans([Python snapshot, pickle

Inference is a statistical technique\
- implications
])

Inference - how to extract info from the data and model

- MLEs Maximum likelihood estimators
- EM expecation-maximization algorithms
- GGM generalized method of moments

MLE has become the standard for Hawkes model 

== Simulation Algorithms
sensitivity analyses
- important as it allow you to identify which parameter your model is most sensitive in
- it is the most important in policy making

=== Nonlinear Hawkes
The self-inhibitory effects are used in neuronial dynamics


=== Mutually Exciting Hawkes






