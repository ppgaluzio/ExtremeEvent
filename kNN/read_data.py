#!/usr/bin/env python

import glob
import numpy as np
import os
import matplotlib.pyplot as pl
import seaborn as sns

from extrevent import ExtremeEvent

sns.set(style='white')

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
        ts[i] = ExtremeEvent().readts(filename)
        median[i] = ts[i].median
        sd[i] = ts[i].std

    medall = np.median(median)
    sdall = np.mean(sd)

    threshold = medall + THRESHOLD_FACTOR * sdall

    fig = ts[0].plot(threshold)
    pl.close(fig)

    pass

if __name__ == '__main__':
    main()
