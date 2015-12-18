#################################################
# UTILITIES
################################################
from numpy import *
from math  import *

# Function to minimize 
def f(x1,x2):
    return 21.5 + x1*sin(4*pi*x1) + x2*sin(20*pi*x2) 

# Total aptitude for calculation chomosome selection
def TotalAptitude(x1,x2,n):
    sum = 0.
    for i in range(0,n):
        sum += f(x1[i], x2[i])
    return sum

# Population (generates m chomosomes)
def Population(m):
    g  = []
    
    for i in range(0,m):
        
#        b = random.choice([0, 1], 33, p=[1./3, 2./3])
        b = random.choice([0, 1], 33, p=[1./2, 1./2])
        g.append(b.tolist())
        
    return g

# Population coordinates
def Coordinates(g,m):
    x1d = []
    x2d = []
    
    for i in range(0,m):
        
        x1 = g[i][0 :18]
        x2 = g[i][18:33]
        
        x1 = int(''.join([str(x) for x in x1]) , 2)
        x2 = int(''.join([str(x) for x in x2]) , 2)        

        x1d.append(-3.0 + x1 * (12.1 + 3.0)/(2.**18 - 1.))
        x2d.append( 4.1 + x2 * ( 5.8 - 4.1)/(2.**15 - 1.))
        
    return x1d,x2d

# Aptitude-based parent selection
def Parents(g,x1,x2,m):

    # First calculate selection probabilities
    sum = 0.
    p   = []   # selection probability 
    q   = []   # cumulative probabolity
    F   = TotalAptitude(x1,x2,m)

    for i in range(0,m):    
        p.append( f(x1[i], x2[i])/F )
        sum += p[i]
        q.append(sum)

    # Now choose parents based on aptitude
    gparent = []
    iparent = []

    for i in range(0,m):
        u = random.random()
        j = 0
        while q[j] <= u: j += 1
        gparent.append(g[j])
        iparent.append(j)

#    return iparent, gparent
    return gparent

# Random pair selection
def PairRecombination(g, m):

    # Recombination probability
    prec = 0.25

    # Random selection of pairs
    irec = []
    nrec = 0

    for i in range(0,m):

        r = random.random()
        if r < prec:        
            irec.append(i)
            nrec += 1

    if nrec % 2 != 0:
        irand = 0
        while irand not in irec:
            irand = random.randint(0,m)
        irec.append(irand)
        
    itmp = irec[:]

    # Choose pairs and recombine
    while len(itmp) > 1:

        icrx = random.randint(0,33)

        r1 = random.randint(0, len(itmp))
        elem1 = itmp[r1]
        itmp.pop(r1)

        r2 = random.randint(0, len(itmp))
        elem2 = itmp[r2]
        itmp.pop(r2)

        # swap elements at icrx:  
        g[elem1][icrx:], g[elem2][icrx:] = g[elem2][icrx:], g[elem1][icrx:]

    return

# Mutation
def Mutation(g, m):

    k = 33
    mutationProb = 0.01
    positions = []

    for i in range(0,k*m):

        u = random.random()
        if u < mutationProb: positions.append(i)

    for i in positions:

        if i%k == 0: numChrom = int(i / k)
        else: numChrom = int(i // k + 1)

        posChrom = int(k - (numChrom*k - i))

        bit = g[numChrom-1][posChrom-1]

        # 'change 0 -> 1'
        if bit == 0: bit = 1
        # 'change 1 -> 0'
        else: bit = 0

        g[numChrom-1][posChrom-1] = bit

    return
