import numpy as np
import matplotlib.pyplot as pl
import seaborn as sns
from scipy.signal import savgol_filter

sns.set(style='white')


class ExtremeEventIdentifier:

    def __init__(self, timeseries):
        """Identify the occurrence of extreme events in the given time series

        """
        self.timeseries = timeseries

    def select_X_y(self):
        """identifies the extreme events and select a X and y pair for each
        one, tries to select the same amount of pairs for non extreme
        events as well

        """
       coordinates = find_ext_events_coordinates(self.timeseries)

        pass


def find_ext_events_coordinates(timeseries):
    """given a time series and a threshold, returns the index of the
    maximum point and of the first point of all the extreme events

    """

    smoothx = apply_smooth_filter_to_x(timeseries)
    mask = is_above_threshold(smoothx, timeseries.threshold)
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
    pass


def get_index_of_max_points(coordinates, timeseries.x):
    """given the coordinates of extreme events, returns the coordinates of the peaks
    """
    pass


def get_index_of_beggining_and_end_of_extreme_event(mask):
    """return a list with the index of where the extreme event starts and ends

    """
    pass


def is_above_threshold(smoothx, threshold):
    """return a mask with true wheneve the smoth time series is
    above the threshold valueñ

    """
    pass


def apply_smooth_filter_to_x(timeseries):
    windowlenght = find_optimal_window_length(timeseries.x)
    smoothx = savgol_filter(timeseries.x,)
    return smoothx


def find_optimal_window_length(x):
    """find the optimal length for the savgol filter
    """
    pass
