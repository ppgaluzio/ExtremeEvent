import numpy as np
import matplotlib.pyplot as pl
import seaborn as sns

sns.set(style='white')


class TimeSeriesContainer:
    """Reads and stores time series

    """

    def __init__(self, threshold_factor):
        self.t = None           # time array
        self.x = None           # time series array
        self.threshold_factor = threshold_factor
        pass

    def read(self, filename):
        """read the time series from `filename`

        Parameters
        ----------
        filename : str
            path to the file where the time series is stored, the data
            must be saved in the following format:

            t0 x0
            t1 x1
            t2 x2
            ....

        """
        self.t, self.x = np.loadtxt(filename, unpack=True)
        return self

    def __len__(self):
        return len(self.t)

    @property
    def dt(self):
        return np.round(np.mean(self.t[1:] - self.t[:-1]), decimals=2)

    @property
    def median(self):
        """return the median of the time series
        """
        return np.median(self.x)

    @property
    def std(self):
        """return the standard deviation of the time series`
        """
        return np.std(self.x)

    @property
    def threshold(self):
        return self.median + self.threshold_factor * self.std


def plot_ts(t, x, threshold=None):
    """simple wrapper to plot time series
    """
    fig, ax = pl.subplots(1, 1, constrained_layout=True)

    ax.plot(t, x, 'k-')
    ax.set_xlabel('t')
    ax.set_ylabel('x')
    if threshold is not None:
        ax.axhline(y=threshold, ls='--', color='r')
    return fig
