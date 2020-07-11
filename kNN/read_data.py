#!/usr/bin/env python

import glob
import numpy as np
import os
import matplotlib.pyplot as pl

from time_series import TimeSeriesContainer
from time_series import plot_ts


FOLDER = "../NLSE"

THRESHOLD_FACTOR = 1

TIME_WINDOW_LENGTH = 50


def main():

    # read time series
    files = glob.glob(os.path.join(FOLDER, "*.dat"))

    # create the array to store the time series
    ts = np.empty(len(files), dtype=object)
    median = np.empty(len(files))
    sd = np.empty(len(files))

    for i, filename in enumerate(files):
        ts[i] = TimeSeriesContainer(THRESHOLD_FACTOR).read(filename)
        median[i] = ts[i].median
        sd[i] = ts[i].std

    fig = plot_ts(ts[0].t, ts[0].x, ts[0].threshold)
    pl.close(fig)

    pass


if __name__ == '__main__':
    main()
