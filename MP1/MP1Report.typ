#import "@preview/physica:0.9.4": *
#import "@preview/tblr:0.4.1": *
#set text(font:"New Computer Modern",size:10pt)
#set page(margin: (x:1in,bottom:1.3in,top:0.75in),
  footer: context[#align(center)[
    #line(length:100%,stroke:0.5pt)#v(-0.11in)
    Proceedings of the Samahang Pisika ng Pilipinas\
    43$""^("rd")$ Samahang Pisika ng Pilipinas Physics Conference\
    University of the Philippines Diliman, Quezon City, 25-28 June 2025\
    #here().page()
  ]],
)
#set par(leading: 0.5em,justify: true,first-line-indent: 1.5em)

#set heading(numbering: "1.1  ")
#show heading.where(level: 1): set text(size: 12pt)
#show heading.where(level: 2): set text(size: 10pt)

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.caption: set align(left)
#show figure.caption: set text(9pt)



#align(center)[
#text(size: 14pt)[*Report: Birth-Death Process Simulation and Analysis*]

  #text(size:9pt)[
  Amancio II S. Manceras$""^("*")$\

  _University of Southern Mindanao, Kabacan, Cotabato_\
  $""^(*)$Corresponding author: asmanceras\@usm.edu.ph

]]

#set math.equation(numbering: "(1)")

#rect(width: 100%,stroke: none,inset: (x:0.4in),[#text(size:9pt)[
*Abstract*\
We explore the stochastic dynamics of a simple birth-death process. Two complementary approaches are applied: the  chemical master equation (CME), and the Stochastic Simulation Algorithm (SSA) introduced by Gillespie. Both approaches were implemented numerically and compared for a system with linear birth and death rates. Results show excellent agreement between the ensemble statistics of the SSA and the solutions of the CME, for both the mean population size and its variance. The results confirm the consistency of stochastic trajectory simulations with the theoretical framework of the CME.\ \
Keywords: Stochastic simulations, biological systems modelling
]])


= Birth-Death process setup

We consider a birth-death process describing the stochastic evolution of a population $N(t)$. The system is governed by two reactions:
#set math.mat(row-gap: -0.1em)
$
 mat(delim: #none,
,""_(b N),;
"Birth:" N,-->,N+1;
)
$
$
 mat(delim: #none,
,""_(c N),;
"Death:" N,-->,N-1;
)
$

where $b$ is the birth rate constant and $c$ is the death rate constant. We simulated the dynamics of this process using the chemical master equation (CME) and through the Stochastic Simulation Algorithm (SSA) by Gillespie. For both approaches, the simulation parameters used are detailed in @tab1.

#figure(
  table(columns: 3,stroke: none,align: (left,center,center),
  table.hline(stroke: 1pt),
  [Parameter],[Variable],[Value],
  table.hline(stroke: .5pt),
  [Birth Rate],[$b$],[0.5],
  [Death Rate],[$c$],[0.4],
  [Initial Population],[$N_(0)$],[50],
  [Final Time],[$T$],[10],
  table.hline(stroke: 1pt),
  ),
  caption: [Simulation parameters used for CME and SSA.],
)<tab1>

= Master Equation
The probability distribution $P(N,t)$ of the population $N$ at a specific time $t$ evolves according to the CME @VANKAMPEN200796. The CME for this system is given by
$
dv(P(N,t),t) = underbrace(b(N-1)P(N-1,t),"state" N-1 -> N) + underbrace(c(N+1)P(N+1,t),"state" N+1 -> N) - underbrace((b N + c N)P(N,t), "state" N->N)
$
#h(1.5em)The CME has three components. The first term is the probability of moving from a state $N-1$ to the target state $N$. The second term is the probability of moving from the state $N+1$ to $N$. And the last term is the probability that the system is already at state $N$ and does not move to other states.

In matrix form, this can be written as:
$
dv(vb(P)(t),t) = A vb(P)(t)
$
where 
$
vb(P)(t) = (P(0,t),P(1,t),...,P(N_("max"),t))^(T)
$
is the probability distribution vector and $A$ is the transition rate matrix. From the probability distribution vector we can calculate the mean trajectory
$
expectationvalue(N(t)) = sum_(N=0)^(oo) N P(N,t)
$
and the variance
$
"Var"[N(t)] = sum_(N=0)^(oo) N^2 P(N,t) - expectationvalue(N(t))^2
$
from which we got the standard deviation.

= Stochastic Algorithm
The SSA, introduced by Gillespie @GILLESPIE1976403, simulate exact paths of a stochastic chemical system. It is an alternative to the traditional procedure of numerically solving the deterministic CMA @Gillespie2007. The first step is to calculate the reaction propensities at an initial state $N$. For our systems these are
$
a_("birth") = b N, #h(1em) a_("death") = c N
$
Then the time for the next reaction is drawn from an exponential distribution. Then a random reaction is selected proportional to its propensity. The chosen reaction is applied, updating the state and time is advanced.

This steps are written in a python code by roughly following the tutorial by Saint-Antoine @saintantoine2020youtube.

= Numerical Simulation
The CME was integrated numerically via ODE solvers (using `scipy.solve_ivp`). The probability distribution vector $vb(P)(t)$ was truncated at $N_("max") = 300$. Using the calculated $vb(P)(t=10)$, the probability distribution for time $t=10$ was generated for CME. 

For SSA, we ran $10^(4)$ trajectories. The mean of this $10^(4)$ trajectories was calculated, along with the standard deviation. A histogram for $t=10$ was generated to produce the probability distribution for SSA.

= Discussion

#figure(
  image("images/fig01.png", width: 60%),
  caption: [
    (Left) Population trajectories over time for SSA and CME. (Right) Probability distribution for $t=10.0$for both SSA and CME.
  ],
)<fig1>



@fig1 (Left) shows the generated trajectories by the SSA as well as the mean trajectory from the CMA. @fig1 (Right) shows the probability distribution at a fixed time ($t = 10$). The histogram constructed from SSA trajectories aligns with the distribution obtained by numerically integrating the CME, showing that both approaches lead to the same stationary and transient behaviours. 

@fig2 Shows the mean trajectory and standard deviation for SSA and CME. The results for both the SSA and the deterministic CME demonstrates strong consistency across multiple statistical measures. This agreement confirms that the master equation correctly captures the expected dynamics of the process, while the SSA provdes a sampling based estimate that converges to the same behavior when sufficiently many trajectories are simulated.

#figure(
  image("images/fig02.png", width: 60%),
  caption: [
    Mean trajectories with standard deviation for SSA and CME.
  ],
)<fig2>\

The variance of the population shows the same correspondence. The confidence intervals derived from the CMO solution overlap with those estimated from the SSA ensemble (shaded area in @fig2). This indicates that the stochastic fluctuations are accurately reproduced in both frameworks. This highlights that the CME provides direct access to statistical moments and the full probability distribution @Szkely2014, while the SSA allows us to observe the variability and randomness inherent to individual realization.

Overall, the comparison underscores a central principle in stochastic process modeling. The master equation provides an exact but high-dimensional description of probability evolution and the Gillespie algorithm offers a practical way to generate realizations that statistically converge to the same distributions. The agreement of both methods is crucial in systems biology and population dynamics, where one often relies on SSA simulations in cases where the CME becomes computationally intractable due to large state spaces.
#set heading(numbering: none)


#bibliography("ref.bib",title:"References",style: "ieee")
