from numpy import *
from pylab import *
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

fig, ax = plt.subplots()
ax  = Axes3D(fig)
ax  = fig.gca(projection='3d')

x = arange(-3, 12.1, 0.15)
y = arange(4.1, 5.8, 0.15)

x, y = meshgrid(x, y)

z = 21.5 + x*sin(4*pi*x) + y*sin(20*pi*y)

ax.plot_surface(x, y, z, rstride=8, cstride=8, alpha=0.4, cmap='hot')

ax.plot([-1,0,3,4], [4.1,4.5,5.,5.3], 0, 'ro')

cset = ax.contour(x, y, z, zdir='z', offset= 0, cmap=cm.coolwarm)
cset = ax.contour(x, y, z, zdir='x', offset=-5, cmap=cm.coolwarm)
cset = ax.contour(x, y, z, zdir='y', offset= 6, cmap=cm.coolwarm)

ax.set_xlabel('x')
ax.set_xlim(-5, 13)
ax.set_ylabel('y')
ax.set_ylim(4, 6)
ax.set_zlabel('f(x,y)')
ax.set_zlim(0, 35)


show()

