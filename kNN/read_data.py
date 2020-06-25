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

    for i, filename in enumerate(files):
        ts[i] = np.loadtxt(filename)


    pass

if __name__ == '__main__':
    main()
