
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d
from scipy.integrate import solve_ivp
import random


#------------------------------------------------
# Stochastic Simulation Algorithm (SSA) function
#------------------------------------------------
def SSArun(N0, reactions, b, c, T):

#    Perform one run of the SSA (Gillespie algorithm) for a simple
#    birth-death process:
#        Birth: N → N+1 with rate b*N
#        Death: N → N-1 with rate c*N
#
#    Parameters
#    ----------
#    N0 : int
#        Initial population
#    reactions : list
#        State changes per reaction (here [1, -1])
#    b : float
#        Birth rate constant
#    c : float
#        Death rate constant
#    T : float
#        Maximum simulation time
#
#    Returns
#    -------
#    t : list of floats
#        Time trajectory
#    N : list of ints
#        Population trajectory
#
    N = [N0]
    t = [0]

    while t[-1] < T:
        # Propensities (reaction rates)
        rates = [b * N[-1], c * N[-1]]
        rsum = sum(rates)

        # Draw waiting time from exponential distribution
        dt = np.random.exponential(scale=1 / rsum)
        t.append(t[-1] + dt)

        # Choose which reaction fires (birth or death)
        rchoice = random.choices(reactions, weights=rates, k=1)
        N.append(N[-1] + rchoice[0])

    return t, N


#-------------------------------
# Parameters
#-------------------------------
nruns = 10000        # number of SSA trajectories
T = 10               # simulation horizon
b = 0.5              # birth rate
c = 0.4              # death rate
N0 = 50              # initial population
reactions = [1, -1]  # birth = +1, death = -1
tvals = np.linspace(0, T, 100)   # evaluation time grid
Nvals = np.zeros((len(tvals), nruns))  # storage for SSA trajectories
Nmax = 300           # maximum state size (for master equation truncation)


#-------------------------------
# Plot SSA trajectories
#-------------------------------
f, axes = plt.subplot_mosaic('AAAB')
f.set_size_inches(6, 4)

for run in range(nruns):
    t, N = SSArun(N0, reactions, b, c, T)

    # Plot a subset of trajectories for visualization
    if run < 40:
        axes["A"].plot(t, N, color="gray")
    if run == 40:
        axes["A"].plot(t, N, color="gray", label="SSA")

    # Interpolate trajectory to fixed time grid for averaging
    f_linear = interp1d(t, N, kind="linear", fill_value="extrapolate")
    Nvals[:, run] = f_linear(tvals)

# Configure SSA trajectory plot
axes["A"].set_ylim(0, Nmax)
axes["A"].set_xlim(0, T)
axes["A"].set_xlabel("Time $t$")
axes["A"].set_ylabel("Population $N$")

# Histogram of SSA distribution at final time
axes["B"].hist(Nvals[-1, :], 200, density=True,
               orientation="horizontal", color="gray")
axes["B"].set_ylim(0, Nmax)


#-------------------------------
# Master Equation formulation
#-------------------------------
# Build rate matrix A for dP/dt = A P
A = np.zeros((Nmax + 1, Nmax + 1))

for N in range(Nmax + 1):
    if N > 0:
        A[N, N - 1] = b * (N - 1)   # probability inflow from N-1 → N (birth)
    if N < Nmax:
        A[N, N + 1] = c * (N + 1)   # inflow from N+1 → N (death)
    A[N, N] = -(b * N + c * N)      # outflow (leaving state N)

# ODE system for probability evolution
def master_eq(t, P):
    return A @ P

# Initial condition: all probability concentrated at N0
P0 = np.zeros(Nmax + 1)
P0[N0] = 1.0

# Solve master equation over [0, T]
sol = solve_ivp(master_eq, (0, T), P0, t_eval=tvals)

# Distribution at final time
P_final = sol.y[:, -1]

# Plot master equation distribution
axes["B"].plot(P_final, range(Nmax + 1), color="black")


#-----------------------------------------
# Mean and variance from master equation
#-----------------------------------------
states = np.arange(Nmax + 1)
meanN = np.sum(states[:, None] * sol.y, axis=0)
varN = np.sum((states[:, None] ** 2) * sol.y, axis=0) - meanN ** 2

# Plot mean trajectory
axes["A"].plot(sol.t, meanN, color="black", label="Master Equation")

# Format plots
axes["B"].set_yticks([])
axes["A"].set_title("Population Trajectories")
axes["A"].legend()
axes["B"].set_title("Probability\n Distribution")
axes["B"].set_xlabel("$P(N,t=10.0)$")
plt.tight_layout()
plt.savefig("images/fig01.png")


#---------------------------------------------------
# Compare mean & variance (SSA vs Master Equation)
#---------------------------------------------------
plt.figure(figsize=(6, 4))

# SSA sample statistics
meanSim = np.mean(Nvals, axis=1)
varSim = np.var(Nvals, axis=1, ddof=0)

# 1-standard deviation envelopes
plt.fill_between(tvals, meanSim - np.sqrt(varSim),
                 meanSim + np.sqrt(varSim), alpha=0.3, color="gray")
plt.fill_between(sol.t, meanN - np.sqrt(varN),
                 meanN + np.sqrt(varN), alpha=0.3, color="black")

# Mean trajectories
plt.plot(sol.t, meanN, color="black", label="Master Equation")
plt.plot(tvals, meanSim, color="gray", label="SSA")

# Formatting
plt.title("Mean trajectory and standard deviation")
plt.ylabel("Population $N$")
plt.xlabel("Time $t$")
plt.xlim(0, T)
plt.legend()

plt.savefig("images/fig02.png")

