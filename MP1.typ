#set par(justify: true)
#set page(columns: 2)
= Guillespie SSA Code

We simulate a DNA transcription-translation system using Gillespie's stochastic simulation algorithm. We determine the population of mRNA and proteins in a system with the following reactions:

$
"Reaction" &| "Rate"\
0 -> X &| k_(t x)\
X -> 0 &|  " "gamma_(m)X\
0 -> Y &| " "k_(t l)X\
Y -> 0 &| " " gamma_(p)Y

$

The parameters used in the simulation are

#table(columns: (auto,auto),
  table.header([parameter],[value]),
$k_(t x)$, [1.0],
$ gamma_(m)$, [0.2],
$k_(t l)$, [5.0],
$ gamma_(p)$, [0.05]
)

Realization from time $t=0$ to $t=1000$ were generated for each run.

== Trajectories

== Enseble Averages and variances

== Stationary distributions
