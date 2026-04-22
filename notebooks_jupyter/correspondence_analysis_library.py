

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
