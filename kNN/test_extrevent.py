import matplotlib.pyplot as pl

from extrevent import ExtremeEventIdentifier
from time_series import TimeSeriesContainer
from time_series import plot_ts


ts = TimeSeriesContainer(1)
ts.read("nlse.dat")

fig = plot_ts(ts.t, ts.x, threshold=ts.threshold)

averagesize = 100
ee = ExtremeEventIdentifier(ts, averagesize)
coords = ee.select_X_y()

for i in range(len(coords)):
    index = coords[i, 0]
    pl.plot(ts.t[index-averagesize:index+averagesize],
            ts.x[index-averagesize:index+averagesize], 'b')

pl.plot(ts.t[coords[:, 0]], ts.x[coords[:, 0]], 'ro')
