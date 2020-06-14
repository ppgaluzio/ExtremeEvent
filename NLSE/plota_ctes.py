#!/usr/bin/python

# -*- coding: utf-8 -*-

from pylab import *
import matplotlib.gridspec as gridspec
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
from matplotlib import cm

DATA = np.loadtxt("ctes.dat") 

t = DATA[:,0]
m = DATA[:,1]
e = DATA[:,2]
h = DATA[:,3]

figure(figsize=(12,6), dpi=72)
gs = gridspec.GridSpec(1,2)

ax0 = subplot(gs[0])
ax0.plot(t,m,label='$M$')
ax0.plot(t,e,label='$E$')
ax0.plot(t,h,label='$H$')
xlabel(r'$t$',fontsize=20)
legend(loc='upper left')

##########################################################################

PERFIL = np.loadtxt("perfil.dat")

t = PERFIL[:,0]
x = PERFIL[:,1]
psi = PERFIL[:,2]

ax1 = subplot(gs[1])

t, x = np.meshgrid(t, x)
surf = ax1.plot_surface(t, x, psi, rstride=1, cstride=1, cmap=cm.coolwarm,
                       linewidth=0, antialiased=False)
colorbar(surf, shrink=0.5, aspect=5)

show()

