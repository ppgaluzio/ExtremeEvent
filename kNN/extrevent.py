import numpy as np
import matplotlib.pyplot as pl
import seaborn as sns
sns.set(style='white')


def find_ext_event_id_of_max(x, threshold):
    """given a time series and a threshold, returns the index of the
    maximum point of an extreme evente

    """



class ExtremeEvent(object):
    """Reads time series and identifies extreme events information

    """

    def __init__(self):
        self.t = None           # time array
        self.x = None           # time series array
        pass

    def readts(self, filename):
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

    def plot(self, threshold=None):
        fig, ax = pl.subplots(1, 1, constrained_layout=True)

        ax.plot(self.t, self.x, 'k-')
        ax.set_xlabel('t')
        ax.set_ylabel('x')
        if threshold is not None:
            ax.axhline(y=threshold, ls='--', color='r')
        return fig

    # select X y ##############################################################

    def select_X_y(self, threshold):
        """identifies the extreme events and select a X and y pair for each
        one, tries to select the same amount of pairs for non extreme
        events as well

        """
        id_of_maxpoints = find_ext_event_id_of_max(self.x, threshold)

        pass

    # properties ##############################################################

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
