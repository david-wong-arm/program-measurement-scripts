#!/usr/bin/python3
import pandas as pd
import numpy as np
import warnings
import datetime
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import ConnectionPatch
from matplotlib import style
from adjustText import adjust_text
import copy
from capeplot import CapePlot
from capeplot import CapeData
from metric_names import MetricName
from statistics import median
import math
import numpy as np
# Importing the MetricName enums to global variable space
# See: http://www.qtrac.eu/pyenum.html
globals().update(MetricName.__members__)

warnings.simplefilter("ignore")  # Ignore deprecation of withdash.

class ScurveAllPlot(CapePlot):
    def __init__(self, data, variant, outputfile_prefix, scale, title, no_plot, gui=False, x_axis=None, y_axis=None, 
                 source_order=None, mappings=pd.DataFrame(), short_names_path=''):
        super().__init__(data, variant, outputfile_prefix, scale, title, no_plot, gui, x_axis, y_axis, 
                         default_y_axis=MetricName.CAP_FP_GFLOP_P_S, mappings=mappings, short_names_path=short_names_path)
    
    def plot_data(self, title, filename, xs, ys, mytexts, scale, df, color_labels, \
        x_axis=None, y_axis=None, mappings=pd.DataFrame()):
        # Scurve doesn't support mappings
        mappings = pd.DataFrame()
        # Get median value of data
        self.median = median(ys.tolist())
        mytext = self.mk_labels()
        temp_df = pd.DataFrame()
        temp_df['x-metric'] = xs.tolist()
        temp_df['y-metric'] = ys.tolist()
        temp_df['label'] = mytext
        temp_df = temp_df.sort_values(by=['x-metric'])
        mytexts = np.array(temp_df['label'].tolist())
        ys = np.array(temp_df['y-metric'].tolist())
        xs = np.array([i for i in range(len(ys))])
        if x_axis: x_axis = 'Ranked Order (' + x_axis + ')'
        else: x_axis = 'Ranked Order (' + self.default_x_axis + ')'
        super().plot_data(title, filename, xs, ys, mytexts, scale, df, color_labels, \
            x_axis, y_axis, mappings)

    def plot_markers_and_labels(self, df, xs, ys, mytexts, color_labels):
        ax = self.ax
        markers = []
        df.reset_index(drop=True, inplace=True)
        # for x, y, label in zip(xs, ys, mytexts):
        #     markers.extend(ax.plot(x, y, marker='o', color='blue', 
        #                            label=label, linestyle='', alpha=1))
        for x, y, color, name, timestamp in zip(xs, ys, df['Color'], df[NAME], df[TIMESTAMP]):
            if color in color_labels: # Check if the color is a user specified name, then get the actual color
                color = color_labels[color]
            markers.extend(ax.plot(x, y, marker='o', color=color, 
                                   label=name+str(timestamp), linestyle='', alpha=1))

        texts = [plt.text(x, y, mytext, alpha=1) for x, y, mytext in zip(xs, ys, mytexts)]
        return texts, markers

    def draw_contours(self, xmax, ymax, color_labels):
        plt.axhline(y=self.median)

def scurve_all_plot(df, outputfile, scale, title, no_plot, variants, gui=False, x_axis=None, y_axis=None, \
    source_order=None, mappings=pd.DataFrame(), short_names_path=''):
    df[MetricName.CAP_FP_GFLOP_P_S] = df[RATE_FP_GFLOP_P_S]
    # Only show selected variants, default is 'ORIG'
    df = df.loc[df[VARIANT].isin(variants)].reset_index(drop=True)
    data = CapeData(df)
    data.compute()
    plot = ScurveAllPlot(data, 'ORIG', outputfile, scale, title, no_plot, gui=gui, x_axis=x_axis, y_axis=y_axis, source_order=source_order, mappings=mappings, short_names_path=short_names_path)
    plot.compute_and_plot()
    return (plot.df, plot.fig, plot.plotData)