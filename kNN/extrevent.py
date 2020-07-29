import numpy as np
import matplotlib.pyplot as pl
import seaborn as sns
from scipy.signal import savgol_filter

sns.set(style='white')


class ExtremeEventIdentifier:

    def __init__(self, timeseries, neighborhood_size):
        """Identify the occurrence of extreme events in the given time series

        """
        self.timeseries = timeseries
        self.neighborhood_size = neighborhood_size

    def select_X_y(self):
        """identifies the extreme events and select a X and y pair for each
        one, tries to select the same amount of pairs for non extreme
        events as well

        """
        coordinates = find_ext_events_coordinates(
            self.timeseries, self.neighborhood_size)

        pass


def find_ext_events_coordinates(timeseries, neighborhood_size):
    """given a time series and a threshold, returns the index of the
    maximum point and of the first point of all the extreme events

    """

    mask = timeseries.x > timeseries.threshold
    mask = vote_selection_of_mask_value_based_on_neighbors(
        mask, neighborhood_size)
    coordinates = get_index_of_beggining_and_end_of_extreme_event(mask)
    peaks = get_index_of_max_points(coordinates, timeseries.x)
    overall_coordinates = construct_list_of_tuples_w_coordinates(
        peaks, coordinates)
    return overall_coordinates


def construct_list_of_tuples_w_coordinates(peaks, coordinates):
    """given the index of the peaks in `peaks` and of the coordinates
    (beggining and end) of an extreme event, return a list with tuples
    containing the index of the beggining and of the max of all the
    extreme events
    """
    overall_coordinates = list()
    for coords in zip(coordinates, peaks):
        overall_coordinates.append((coords[0][0], coords[1]))
    return overall_coordinates


def get_index_of_max_points(coordinates, x):
    """given the coordinates of extreme events, returns the coordinates of
    the peaks

    """
    peaks = np.empty(len(coordinates))
    for i, coord in enumerate(coordinates):
        peaks[i] = np.max(x[coord[0]:coord[1]])
    return peaks


def get_index_of_beggining_and_end_of_extreme_event(mask):
    """return a list with the index of where the extreme event starts and ends

    """
    coordinates = np.array(mask[1:] ^ mask[:-1]).nonzero()[0]
    tuples = list()
    for i, coord in enumerate(coordinates):
        if not mask[coord]:
            tuples.append((coordinates[i], coordinates[i+1]))
    return tuples


def vote_selection_of_mask_value_based_on_neighbors(mask, neighborhood_size):
    """each element of the new mask is a majority vote of its neighborhood

    """
    newmask = np.empty_like(mask)
    pad = neighborhood_size // 2
    for i in range(len(mask)):
        newmask[i] = vote_array(mask[i-pad:i+pad])
    return newmask


def vote_array(mask):
    """return the vote for the current element in the mask

    """
    return np.sum(mask) > 0.5 * len(mask)
