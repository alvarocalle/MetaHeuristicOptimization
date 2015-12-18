###################################################
## Genetic Algorithm for optimizing:
## f(x,y)= 21.5 + x sin(4 pi x) +  y sin(20 pi y) 
###################################################
from numpy import *
from math  import *
from pylab import *
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import utils

# *****************************************************
# GA OPTIMIZATION
# *****************************************************
# Store best result for each generation
fmax  = []
x1max = []
x2max = []

n_generations = 1000 # number of generations to run
m_chromo = 20        # number of chromosomes

# First generation
g = utils.Population(m_chromo)
x1, x2 = utils.Coordinates(g,m_chromo)

# Run the algorithm:
for dummy in range(0, n_generations):

    fval = []

    # Select parents
    gp = utils.Parents(g,x1,x2,m_chromo)

    # Recombine
    gr = map(list, gp)
    utils.PairRecombination(gr, m_chromo)

    # Mutate
    gm = map(list,gr)
    utils.Mutation(gm, m_chromo)

    # Update generation
    g = map(list,gm)
    x1, x2 = utils.Coordinates(g,m_chromo)

    for i in range(0,m_chromo):
        fval.append( utils.f(x1[i],x2[i]) )

    # store best result for current generation
    fmax.append( max(fval) )
    x1max.append(x1[fval.index( max(fval) )])
    x2max.append(x2[fval.index( max(fval) )])

fbest  = max(fmax)
x1best = x1max[fmax.index(fbest)]
x2best = x2max[fmax.index(fbest)]
    
# Print results:
print 'Best results:'
print 'Generation:', fmax.index(fbest) 
print 'fbest = ', fbest 
print 'x1best = ', x1best 
print 'x2best = ', x2best 
print 'Now generating a plot ...'

# *****************************************************
# PLOT FUNCTION AND RESULTS
# *****************************************************

vfunc = vectorize(utils.f)

fig, ax = plt.subplots()
ax  = Axes3D(fig)
ax  = fig.gca(projection='3d')

x = arange(-3, 12.1, 0.15)
y = arange(4.1, 5.8, 0.15)

x, y = meshgrid(x, y)

z = vfunc(x,y)

ax.plot_surface(x, y, z, rstride=8, cstride=8, alpha=0.4, cmap='hot')

ax.plot(x1max, x2max, 7.5, 'bo')
ax.plot([x1best], [x2best], 7.5, 'ro')

cset = ax.contour(x, y, z, zdir='z', offset= 5, cmap=cm.coolwarm, alpha=0.1)
cset = ax.contour(x, y, z, zdir='x', offset=-5, cmap=cm.coolwarm)
cset = ax.contour(x, y, z, zdir='y', offset= 6, cmap=cm.coolwarm)

ax.set_xlabel('x')
ax.set_xlim(-5, 13)
ax.set_ylabel('y')
ax.set_ylim(4, 6)
ax.set_zlabel('f(x,y)')
ax.set_zlim(0, 35)


show()

