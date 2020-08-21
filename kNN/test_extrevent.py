import matplotlib.pyplot as pl

from extrevent import ExtremeEventIdentifier
from time_series import TimeSeriesContainer
from time_series import plot_ts


ts = TimeSeriesContainer(2)
ts.read("nlse.dat")

fig = plot_ts(ts.t, ts.x, threshold=ts.threshold)

averagesize = 100
ee = ExtremeEventIdentifier(ts, averagesize)

xlength = int(100 / ts.dt)
pad = int(10 / ts.dt)

X, y = ee.select_X_y(xlength, pad)

# pl.plot(ts.t[coords:, ])
# for i in coords:

#     pl.plot(ts.t[index-averagesize:index+averagesize],
#             ts.x[index-averagesize:index+averagesize], 'b')
