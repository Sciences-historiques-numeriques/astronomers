
import pandas as pd
import sqlite3 as sql
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import networkx as nx
import itertools

import scipy.cluster.hierarchy as sch
from scipy.cluster.hierarchy import fcluster


from sklearn.cluster import KMeans

from prince import MCA




### function variables contribution to clusters
def plot_cluster_heatmap(df_clustered, categorical_cols):
    fig, axes = plt.subplots(1, len(categorical_cols), 
                              figsize=(4 * len(categorical_cols), 5))
    
    for ax, col in zip(axes, categorical_cols):
        ct = pd.crosstab(df_clustered['cluster'], df_clustered[col], normalize='index') * 100
        sns.heatmap(ct, annot=True, fmt=".1f", cmap="YlOrRd", ax=ax, cbar=False,
                    xticklabels=ct.columns,      # category string values as x labels
                    yticklabels=[f"Cluster {i}" for i in ct.index])  # cluster labels as y labels
        ax.set_title(col)
        ax.set_xlabel("")
        ax.set_xticklabels(ax.get_xticklabels(), rotation=45, ha='right', fontsize=8)
        ax.set_yticklabels(ax.get_yticklabels(), rotation=0, fontsize=8)
    
    plt.suptitle("Category distribution (%) per cluster", y=1.02)
    plt.tight_layout()
    plt.show()



## function cluster network
def plot_cluster_networks(df_clustered, categorical_cols, n_clusters):
    fig, axes = plt.subplots(1, n_clusters, figsize=(7 * n_clusters, 7))
    if n_clusters == 1:
        axes = [axes]

    for cluster_id, ax in zip(sorted(df_clustered['cluster'].unique()), axes):
        df_cl = df_clustered[df_clustered['cluster'] == cluster_id]
        n_persons = len(df_cl)

        # Build list of (category_value) nodes per person
        # Each cell value becomes a node, e.g. "gender=Male"
        person_nodes = []
        for _, row in df_cl.iterrows():
            nodes = [f"{col}={row[col]}" for col in categorical_cols]
            #nodes = [f"{row[col]}" for col in categorical_cols]
            person_nodes.append(nodes)

        # Node frequency
        node_freq = {}
        for nodes in person_nodes:
            for node in nodes:
                node_freq[node] = node_freq.get(node, 0) + 1

        # Edge frequency: co-occurrence within same person
        edge_freq = {}
        for nodes in person_nodes:
            for a, b in itertools.combinations(sorted(nodes), 2):
                edge_freq[(a, b)] = edge_freq.get((a, b), 0) + 1

        # Build graph
        G = nx.Graph()
        G.add_nodes_from(node_freq.keys())
        for (a, b), w in edge_freq.items():
            G.add_edge(a, b, weight=w)

        # Layout k=plus haut éloigne les points
        pos = nx.spring_layout(G, seed=42, k=7)

        # Node sizes proportional to frequency
        node_sizes = [node_freq[n] * 30 for n in G.nodes()]

        # Edge widths proportional to co-occurrence
        edge_weights = [G[u][v]['weight'] / n_persons * 10 for u, v in G.edges()]

        # Color nodes by variable
        color_map = {}
        palette = plt.cm.tab10.colors
        for i, col in enumerate(categorical_cols):
            for node in G.nodes():
                if node.startswith(f"{col}="):
                    color_map[node] = palette[i % len(palette)]
        node_colors = [color_map.get(n, 'grey') for n in G.nodes()]

        # Labels: only the category value, strip "variable=" prefix ; strips everything before 
        # and including the =, keeping only the category value for display 
        # while the full variable=category key is still used internally for color mapping and graph logic.
        node_labels = {n: n.split("=", 1)[1] for n in G.nodes()}

        # Draw
        nx.draw_networkx_nodes(G, pos, ax=ax, node_size=node_sizes,
                               node_color=node_colors, alpha=0.85)
        nx.draw_networkx_edges(G, pos, ax=ax, width=edge_weights,
                               alpha=0.4, edge_color='grey')
        nx.draw_networkx_labels(G, pos, ax=ax,  labels=node_labels, font_size=7)

        # Legend for variables
        legend_handles = [
            plt.Line2D([0], [0], marker='o', color='w',
                       markerfacecolor=palette[i % len(palette)],
                       markersize=10, label=col)
            for i, col in enumerate(categorical_cols)
        ]
        ax.legend(handles=legend_handles, loc='upper left', fontsize=7)
        ax.set_title(f"Cluster {cluster_id} — {n_persons} persons", fontsize=11)
        ax.axis('off')

    plt.suptitle(f"Network graph — {n_clusters} clusters", fontsize=14, y=1.02)
    plt.tight_layout()
    plt.show()

