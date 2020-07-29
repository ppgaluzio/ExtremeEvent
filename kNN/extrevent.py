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

        return np.asarray(coordinates, dtype=np.int)


def find_ext_events_coordinates(timeseries, neighborhood_size):
    """given a time series and a threshold, returns the index of the
    maximum point and of the first point of all the extreme events

    """

    mask = timeseries.x > timeseries.threshold
    mask = vote_selection_of_mask_value_based_on_neighbors(
        mask, neighborhood_size)
    fine_coordinates = get_index_of_beggining_and_end_of_extreme_event(mask)
    coarse_coordinates = group_ext_events_closer_than_neighborhood(
        fine_coordinates, neighborhood_size)
    peaks = get_index_of_max_points(coarse_coordinates, timeseries.x)
    overall_coordinates = construct_list_of_tuples_w_coordinates(
        peaks, coarse_coordinates)
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


def group_ext_events_closer_than_neighborhood(fine_coordinates, neighborhood):
    """whenever two extreme events are closer by a distance smaller than
    the neighborhood, group then together

    """
    distance = fine_coordinates[1:, 0] - fine_coordinates[:-1, 1]
    closeptscoord = distance < neighborhood

    coarse_coordinates = aggregate_close_points(
        fine_coordinates, closeptscoord)

    return np.array(coarse_coordinates)


def aggregate_close_points(fine_coordinates, closeptscoord, outputlist=None):
    """given a set of coordinates and a mask on where to glue them, return
    a list with the coordinates aggregated

    Ex.:

    >>> fc = np.array([(1, 2), (2, 3), (3, 4), (5, 6)])
    >>> coord = [False, True, False]
    >>> x = aggregate_close_points(fc, coord)
    [[1, 2], [1, 4], [1, 6]]

    """

    if outputlist is None:
        outputlist = list()

    if len(closeptscoord) == 0:
        outputlist.append(fine_coordinates[0].tolist())
        return outputlist

    if not closeptscoord[0]:
        outputlist.append(fine_coordinates[0].tolist())
    else:
        fine_coordinates[1][0] = fine_coordinates[0][0]

    outputlist = aggregate_close_points(
        fine_coordinates[1:], closeptscoord[1:], outputlist)
    return outputlist


def get_index_of_beggining_and_end_of_extreme_event(mask):
    """return a list with the index of where the extreme event starts and ends

    """
    coordinates = np.array(mask[1:] ^ mask[:-1]).nonzero()[0]
    tuples = list()
    for i, coord in enumerate(coordinates):
        if not mask[coord]:
            tuples.append((coordinates[i], coordinates[i+1]))
    return np.array(tuples)


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
