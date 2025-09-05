import numpy as np
import matplotlib.pyplot as plt
import random

state = np.array([[
        0, # number of mRna
        0 # number of protein
    ]])


transition = np.array([
        [1,0],  # transcription
        [-1,0],  # mRNA decay
        [0,1],  # translation
        [0,-1]   # protein decay
    ])

ktx = 1
gm = 0.2
ktl = 5
gp = 0.05

tend = 1000

t = [0]

rate = []

x = 0 # collects mRNA count
y = 0 # collects protein count

print(state[-1],transition,rate)

while t[-1] < tend:
    
    rate = [ktx,state[-1,0]*gm,state[-1,0]*ktl,state[-1,1]*gp]

    rsum = sum(rate)


    dt = np.random.exponential(scale=1/rsum)

    t.append(t[-1]+dt)

    rchoice = random.choices(transition, weights=rate, k=1)


    print(rchoice)

    state = np.append(state, state[-1]+rchoice, axis=0)

print(state)

plt.plot(t,state[:,0])
plt.plot(t,state[:,1])
plt.show()
#    print(rchoice)
#    x.append(x[-1]+rchoice[0])

#plt.plot(t,x)
#plt.show()




