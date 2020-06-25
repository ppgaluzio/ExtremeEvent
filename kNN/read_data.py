#!/usr/bin/env python

import glob
import numpy as np
import os
import matplotlib.pyplot as pl
import seaborn as sns

sns.set(style='ticks')

FOLDER = "../NLSE"


def main():

    # read time series
    files = glob.glob(os.path.join(FOLDER, "*.dat"))

    # create the array to store the time series
    ts = np.empty(len(files), dtype=object)
    median = np.empty(len(files))
    sd = np.empty(len(files))

    for i, filename in enumerate(files):
        ts[i] = np.loadtxt(filename)
        median[i] = np.median(ts[i][:, 1])
        sd[i] = np.std(ts[i][:, 1])

    medall = np.median(median)
    sdall = np.mean(sd)

    pass

if __name__ == '__main__':
    main()
