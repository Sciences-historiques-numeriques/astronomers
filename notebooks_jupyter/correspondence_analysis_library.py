

import pandas as pd
import numpy as np
import scipy.stats as stats
import statsmodels.api as sm
from fanalysis.ca import CA 

import matplotlib.pyplot as plt
import seaborn as sns




def print_eigenvalue(afc):

    eig = pd.DataFrame(afc.eig_)

    r1 = round(eig.iloc[0], 3)
    r2 = round(eig.iloc[2], 2)
    s=list(range(1,len(r1)+1))
    r1.index=s
    r2.index=s

    # https://www.statology.org/pandas-subplots/
    fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12,3))

    ax1 = r1.plot(kind='bar', ax=axes[0], title='Eigenvalue des axes')
    ax2 = r2.plot(kind='bar', ax=axes[1], title="Frequence cumulative de l'eigenvalue ")


    ax1.bar_label(ax1.containers[0])
    ax2.bar_label(ax2.containers[0])


    # Met les valeurs xticks en vertical
    fig.autofmt_xdate(rotation=0)
    plt.show()




def dim_contributions(afc):
    
    # Informations sur les contributions des colonnes
    df = afc.col_topandas()[['col_contrib_dim1',
                            'col_contrib_dim2',
                            'col_contrib_dim3']]

    # limit to 10 most frequent
    r1 = df.iloc[:10,0]
    r2 = df.iloc[:10,1]
    r3 = df.iloc[:10,2]

    fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(12,6), )

    r1.sort_values().plot(kind='barh', ax=axes[0,0], title='Dim.1')
    r2.sort_values().plot(kind='barh', ax=axes[0,1], title='Dim.2')
    r3.sort_values().plot(kind='barh', ax=axes[0,2], title='Dim.3')

    ### Rows
    df = afc.row_topandas()[['row_contrib_dim1',
                            'row_contrib_dim2',
                            'row_contrib_dim3']]
    
    
    # limit to 10 most frequent
    r1 = df.iloc[:10,0]
    r2 = df.iloc[:10,1]
    r3 = df.iloc[:10,2]

    r1.sort_values().plot(kind='barh', ax=axes[1,0], title='Dim.1')
    r2.sort_values().plot(kind='barh', ax=axes[1,1], title='Dim.2')
    r3.sort_values().plot(kind='barh', ax=axes[1,2], title='Dim.3')

    plt.tight_layout()
    plt.show()


def dim_cos2_repr_quality(afc):
    
    # Informations sur les contributions des colonnes
    df = afc.col_topandas()[['col_cos2_dim1',
                            'col_cos2_dim2',
                            'col_cos2_dim3']]

    # limit to 10 most frequent
    r1 = df.iloc[:10,0]
    r2 = df.iloc[:10,1]
    r3 = df.iloc[:10,2]

    fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(12,6), )

    r1.sort_values().plot(kind='barh', ax=axes[0,0], title='Dim.1')
    r2.sort_values().plot(kind='barh', ax=axes[0,1], title='Dim.2')
    r3.sort_values().plot(kind='barh', ax=axes[0,2], title='Dim.3')

    ### Rows
    df = afc.row_topandas()[['row_cos2_dim1',
                            'row_cos2_dim2',
                            'row_cos2_dim3']]
    
    
    # limit to 10 most frequent
    r1 = df.iloc[:10,0]
    r2 = df.iloc[:10,1]
    r3 = df.iloc[:10,2]

    r1.sort_values().plot(kind='barh', ax=axes[1,0], title='Dim.1')
    r2.sort_values().plot(kind='barh', ax=axes[1,1], title='Dim.2')
    r3.sort_values().plot(kind='barh', ax=axes[1,2], title='Dim.3')

    plt.tight_layout()
    plt.show()




def plot_ca_single_axis(row_coords, col_coords, title="CA — Single axis"):
    fig, ax = plt.subplots(figsize=(18, 3))

    # Extract dim1 coordinates
    row_dim1 = row_coords.iloc[:, 0]
    col_dim1 = col_coords.iloc[:, 0]

    # Plot column points
    ax.scatter(col_dim1, np.zeros(len(col_dim1)),
               color='steelblue', s=100, zorder=3, label='Column categories')
    for label, x in zip(col_coords.index, col_dim1):
        ax.annotate(label, (x, 0),
                    textcoords="offset points", xytext=(0, 12), rotation=45,
                    ha='center', fontsize=8, color='steelblue')

    # Plot row points (Male/Female)
    ax.scatter(row_dim1, np.zeros(len(row_dim1)),
               color='tomato', s=150, zorder=3, marker='D', label='Row categories')
    for label, x in zip(row_coords.index, row_dim1):
        ax.annotate(label, (x, 0),
                    textcoords="offset points", xytext=(20, -40), rotation=-45,
                    ha='right', va='bottom', fontsize=9, color='tomato', fontweight='bold')

    # Axis line
    ax.axhline(0, color='grey', linewidth=0.8, linestyle='--')
    ax.axvline(0, color='grey', linewidth=0.5, alpha=0.5)

    ax.set_yticks([])
    ax.set_xlabel("Dimension 1")
    ax.set_title(title)
    ax.legend(loc='upper right')
    ax.grid(True, alpha=0.2, axis='x')

    plt.tight_layout()
    plt.show()


### Correct and improve some features of fanalysis



def custom_mapping(self, num_x_axis, num_y_axis, short_labels=True, 
                   ax=None, figsize=None):
    """ Plot the Factor map for rows and columns simultaneously on given ax """
    if ax is None:
        fig, ax = plt.subplots(figsize=figsize)
    else:
        fig = ax.get_figure()

    if self.model_ == "mca" and short_labels:
        col_labels = self.col_labels_short_
    else:
        col_labels = self.col_labels_

    # Plot row points (invisible scatter, just for scaling)
    ax.scatter(self.row_coord_[:, num_x_axis - 1],
               self.row_coord_[:, num_y_axis - 1],
               marker=".", color="white", zorder=0)

    # Plot column points (invisible scatter)
    ax.scatter(self.col_coord_[:, num_x_axis - 1],
               self.col_coord_[:, num_y_axis - 1],
               marker=".", color="white", zorder=0)

    # Add row labels
    for i in np.arange(0, self.row_coord_.shape[0]):
        ax.text(self.row_coord_[i, num_x_axis - 1],
                self.row_coord_[i, num_y_axis - 1],
                self.row_labels_[i],
                horizontalalignment="center", verticalalignment="center",
                color="red", zorder=5)

    # Add column labels
    for i in np.arange(0, self.col_coord_.shape[0]):
        ax.text(self.col_coord_[i, num_x_axis - 1],
                self.col_coord_[i, num_y_axis - 1],
                col_labels[i],
                horizontalalignment="center", verticalalignment="center",
                color="blue", zorder=5)

    ax.set_title("Factor map")
    ax.set_xlabel("Dim " + str(num_x_axis) + " ("
                  + str(np.around(self.eig_[1, num_x_axis - 1], 2)) + "%)")
    ax.set_ylabel("Dim " + str(num_y_axis) + " ("
                  + str(np.around(self.eig_[1, num_y_axis - 1], 2)) + "%)")
    ax.axvline(x=0, linestyle="--", linewidth=0.5, color="k", zorder=0)
    ax.axhline(y=0, linestyle="--", linewidth=0.5, color="k", zorder=0)

    return ax  # return ax for further customization



# Use with Monkey-patch in th code: on remplace la fonction de la bibliothèque par celle-ci
# MCA.mapping = custom_mapping




def custom_mapping_col(self, num_x_axis, num_y_axis, short_labels=True,
                    ax=None, figsize=None):
        """ Plot the Factor map for columns only
        
        """

        if ax is None:
            fig, ax = plt.subplots(figsize=figsize)
        else:
            fig = ax.get_figure()

        if self.model_ == "mca" and short_labels:
            col_labels = self.col_labels_short_
        else:
            col_labels = self.col_labels_
        
        ax.scatter(self.col_coord_[:, num_x_axis - 1],
                    self.col_coord_[:, num_y_axis - 1],
                    marker=".", color="white")
        for i in np.arange(0, self.col_coord_.shape[0]):
            ax.text(self.col_coord_[i, num_x_axis - 1],
                     self.col_coord_[i, num_y_axis - 1],
                     col_labels[i],
                     horizontalalignment="center", verticalalignment="center",
                     color="blue")
        ax.set_title("Factor map for columns")
        ax.set_xlabel("Dim " + str(num_x_axis) + " ("
                    + str(np.around(self.eig_[1, num_x_axis - 1], 2)) + "%)")
        ax.set_ylabel("Dim " + str(num_y_axis) + " ("
                    + str(np.around(self.eig_[1, num_y_axis - 1], 2)) + "%)")
        ax.axvline(x=0, linestyle="--", linewidth=0.5, color="k")
        ax.axhline(y=0, linestyle="--", linewidth=0.5, color="k")
        
        return ax 

# Use with Monkey-patch in th code: on remplace la fonction de la bibliothèque par celle-ci
# MCA.mapping_col = custom_mapping_col




def custom_plot_eigenvalues(self, type="absolute", ax=None, figsize=None):
        """ Plot the eigen values graph
        
        Parameters
        ----------
        type : string
            Select the graph to plot :
                - If "absolute" : plot the eigenvalues.
                - If "percentage" : plot the percentage of variance.
                - If "cumulative" : plot the cumulative percentage of
                  variance.
        figsize : tuple of integers or None
            Width, height of the figure in inches.
            If not provided, defaults to rc figure.figsize

        Returns
        -------
        None
        """
        if ax is None:
            fig, ax = plt.subplots(figsize=figsize)

        if type == "absolute":
            ax.bar(np.arange(1, self.eig_[0].shape[0] + 1), self.eig_[0],
                    color="steelblue", align="center")
            ax.set_xlabel("Axis")
            ax.set_ylabel("Eigenvalue")
            ax.set_title("Scree plot: Eigenvalue")
        elif type == "percentage":
            ax.bar(np.arange(1, self.eig_[1].shape[0] + 1), self.eig_[1],
                    color="steelblue", align="center")
            ax.set_xlabel("Axis")
            ax.set_ylabel("Percentage of variance")
            ax.set_title("Scree plot: Percentage")
        elif type == "cumulative":
            ax.bar(np.arange(1, self.eig_[2].shape[0] + 1), self.eig_[2],
                    color="steelblue", align="center")
            ax.set_xlabel("Axis")
            ax.set_ylabel("Cumulative percentage of variance")
            ax.set_title("Scree plot: Cumulative")
        else:
            raise ValueError("Error : 'type' variable must be 'absolute' or \
                            'percentage' or 'cumulative'")
        
        
        ax.grid(True, alpha=0.3)

# Monkey-patch: on remplace la fonction de la bibliothèque par celle-ci
# MCA.plot_eigenvalues = custom_plot_eigenvalues



def custom_plot_row_contrib(self, num_axis, nb_values=None, ax=None, figsize=None):
        """ Plot the eigen values graph
        
        Parameters
        ----------
        type : string
            Select the graph to plot :
                - If "absolute" : plot the eigenvalues.
                - If "percentage" : plot the percentage of variance.
                - If "cumulative" : plot the cumulative percentage of
                  variance.
        figsize : tuple of integers or None
            Width, height of the figure in inches.
            If not provided, defaults to rc figure.figsize

        Returns
        -------
        None
        """
        if ax is None:
            fig, ax = plt.subplots(figsize=figsize)

        n_rows = len(self.row_labels_)
        n_labels = len(self.row_labels_)
        if (nb_values is not None) and (nb_values < n_labels):
            n_labels = nb_values
        limit = n_rows - n_labels
        contribs = self.row_contrib_[:, num_axis - 1]
        contribs_sorted = np.sort(contribs)[limit:n_rows]
        labels = pd.Series(self.row_labels_)[np.argsort(contribs)]\
                                                        [limit:n_rows]
        r = range(n_labels)
        bar_width = 0.5
        ax.set_yticks([ri + bar_width / 2 for ri in r], labels)
        ax.barh(r, contribs_sorted, height=bar_width, color="steelblue",
                 align="edge")
        ax.set_title("Rows contributions")
        ax.set_xlabel("Contributions (%)")
        ax.set_ylabel("Rows")
        
        ax.grid(True, alpha=0.3)

# Monkey-patch: on remplace la fonction de la bibliothèque par celle-ci
# MCA.plot_row_contrib = custom_plot_row_contrib




def custom_plot_col_contrib(self, num_axis, nb_values=None, ax=None, 
                            short_labels=True, figsize=None):
        """ Plot the eigen values graph
        
        Parameters
        ----------
        type : string
            Select the graph to plot :
                - If "absolute" : plot the eigenvalues.
                - If "percentage" : plot the percentage of variance.
                - If "cumulative" : plot the cumulative percentage of
                  variance.
        figsize : tuple of integers or None
            Width, height of the figure in inches.
            If not provided, defaults to rc figure.figsize

        Returns
        -------
        None
        """
        if ax is None:
            fig, ax = plt.subplots(figsize=figsize)

        n_cols = len(self.col_labels_)
        n_labels = len(self.col_labels_)
        if self.model_ == "mca" and short_labels:
            col_labels = self.col_labels_short_
        else:
            col_labels = self.col_labels_
        if (nb_values is not None) and (nb_values < n_labels):
            n_labels = nb_values
        limit = n_cols - n_labels
        contribs = self.col_contrib_[:, num_axis - 1]
        contribs_sorted = np.sort(contribs)[limit:n_cols]
        labels = pd.Series(col_labels)[np.argsort(contribs)][limit:n_cols]
        r = range(n_labels)
        bar_width = 0.5
        ax.set_yticks([ri + bar_width / 2 for ri in r], labels)
        ax.barh(r, contribs_sorted, height=bar_width, color="steelblue",
                 align="edge")
        ax.set_title("Columns contributions")
        ax.set_xlabel("Contributions (%)")
        ax.set_ylabel("Columns")
        
        ax.grid(True, alpha=0.3)

# Monkey-patch: on remplace la fonction de la bibliothèque par celle-ci
# MCA.plot_col_contrib = custom_plot_col_contrib