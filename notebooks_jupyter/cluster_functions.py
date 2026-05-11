
import pandas as pd
import sqlite3 as sql
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import networkx as nx
import itertools
import math

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
def plot_cluster_networks(df_clustered, categorical_cols, n_clusters, pict_address=''):
    # Configuration
    n_cols = 4
    # Calculate rows needed (ceiling division: e.g., 5 clusters -> 2 rows)
    n_rows = math.ceil(n_clusters / n_cols)

    # Create figure with dynamic height based on actual rows needed
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(7 * n_cols, 7 * n_rows))
    
    # Flatten axes to a simple list for easy iteration
    # Handle edge cases where subplots returns a single array or single object
    if n_rows == 1 and n_cols == 1:
        axes = [axes]
    else:
        axes = axes.flatten()

    cluster_ids = sorted(df_clustered['cluster'].unique())



    # Plot each cluster
    for i, cluster_id in enumerate(cluster_ids):
        ax = axes[i]
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

               # Draw Network
        nx.draw_networkx_nodes(G, pos, ax=ax, node_size=node_sizes,
                               node_color=node_colors, alpha=0.85)
        nx.draw_networkx_edges(G, pos, ax=ax, width=edge_weights,
                               alpha=0.4, edge_color='grey')
        nx.draw_networkx_labels(G, pos, ax=ax, labels=node_labels, font_size=7)

        # Legend
        legend_handles = [
            plt.Line2D([0], [0], marker='o', color='w',
                       markerfacecolor=palette[i % len(palette)],
                       markersize=10, label=col)
            for i, col in enumerate(categorical_cols)
        ]
        ax.legend(handles=legend_handles, loc='upper left', fontsize=7)
        
        ax.set_title(f"Cluster {cluster_id} — {n_persons} persons", fontsize=11)
        ax.axis('off')

    # Remove unused axes (the empty spots in the last row)
    for j in range(len(cluster_ids), len(axes)):
        fig.delaxes(axes[j])

    plt.suptitle(f"Network graph — {n_clusters} clusters", fontsize=14, y=1.02)
    plt.tight_layout()

    if len(pict_address) > 3:
        plt.savefig(pict_address, dpi=150, bbox_inches='tight')
    
    plt.show()




def export_cluster_networks_to_gephi(df_clustered, categorical_cols, output_filename):
    """
    Builds SEPARATE network COMPONENTS for each cluster and exports them 
    into a SINGLE GEXF file. Nodes are prefixed to prevent merging between clusters.

    df_clustered: the dataframe with individuals and a 'cluster' column
    
    """
    graphs_list = []
    
    # Prepare a color palette for variables (using tab10 like the original)
    palette = plt.cm.tab10.colors
    var_color_map = {col: palette[i % len(palette)] for i, col in enumerate(categorical_cols)}

    # Iterate through clusters
    unique_clusters = sorted(df_clustered['cluster'].unique())
    print('stupid')
    
    for cluster_id in unique_clusters:
        df_cl = df_clustered[df_clustered['cluster'] == cluster_id]
        n_persons = len(df_cl)

        # 1. Build Nodes and Edges data
        person_nodes = []
        for _, row in df_cl.iterrows():
            nodes = [f"{col}={row[col]}" for col in categorical_cols]
            person_nodes.append(nodes)

        # Node frequency
        node_freq = {}
        for nodes in person_nodes:
            for node in nodes:
                node_freq[node] = node_freq.get(node, 0) + 1

        # Edge frequency
        edge_freq = {}
        for nodes in person_nodes:
            for a, b in itertools.combinations(sorted(nodes), 2):
                edge_freq[(a, b)] = edge_freq.get((a, b), 0) + 1

        # 2. Build Graph
        G = nx.Graph()
        G.add_nodes_from(node_freq.keys())
        for (a, b), w in edge_freq.items():
            G.add_edge(a, b, weight=w)
        
        # Add graph-level metadata (useful in Gephi)
        G.graph['name'] = f"Cluster_{cluster_id}"
        G.graph['cluster_id'] = cluster_id
        G.graph['n_persons'] = n_persons

        # 3. Assign Node Attributes for Gephi
        
        # Calculate sizes (scaled similarly to original plot)
        sizes = {n: node_freq[n] * 30 for n in G.nodes()}
        nx.set_node_attributes(G, sizes, 'size')
        
        # Calculate Colors based on variable prefix
        colors = {}
        for node in G.nodes():
            found_color = 'grey'
            for col, color_val in var_color_map.items():
                if node.startswith(f"{col}="):
                    # Convert matplotlib RGB tuple (0-1) to Hex for Gephi compatibility
                    r, g, b = color_val
                    hex_color = "#{:02x}{:02x}{:02x}".format(int(r*255), int(g*255), int(b*255))
                    found_color = hex_color
                    break
            colors[node] = found_color
        nx.set_node_attributes(G, colors, 'color')
        
        # Labels (strip "variable=" prefix)
        labels = {n: n.split("=", 1)[1] for n in G.nodes()}
        nx.set_node_attributes(G, labels, 'label')

        # 4. Assign Edge Attributes for Gephi
        # Normalize weight similar to original plot logic
        weights = {}
        for u, v in G.edges():
            w = G[u][v]['weight']
            # Store original count and normalized width
            weights[(u, v)] = {
                'weight': w, 
                'count': w, 
                'normalized_width': (w / n_persons * 10) if n_persons > 0 else 0
            }
        
        # Gephi usually reads 'weight' for ranking size. 
        # We set 'weight' to the normalized width so it matches the visual logic of the plot immediately.
        final_weights = { (u, v): data['normalized_width'] for (u, v), data in weights.items() }
        nx.set_edge_attributes(G, final_weights, 'weight')
        
        # Also store raw count as a separate attribute for flexibility in Gephi
        raw_counts = { (u, v): data['count'] for (u, v), data in weights.items() }
        nx.set_edge_attributes(G, raw_counts, 'co_occurrence_count')

        graphs_list.append(G)

    # 5. Export to GEXF
    # If multiple graphs are in the list, write_gexf creates a file with multiple <graph> tags
    if len(graphs_list) == 1:
        nx.write_gexf(graphs_list[0], output_filename)
    else:
        # Create a container graph to hold multiple subgraphs if needed, 
        # but nx.write_gexf handles a list of graphs by creating a GEXF with multiple graph elements 
        # only if passed a specific structure. Standard practice for multiple clusters 
        # is often separate files OR one file with dynamic attributes.
        # Here we will merge them into one graph but add a 'cluster' attribute to nodes/edges 
        # so you can filter in Gephi, OR write the first one if you prefer separate files.
        
        # OPTION A: Single file with all nodes merged (distinguished by cluster attribute)
        # This is usually best for comparing clusters in one view.
        super_G = nx.Graph()
        for i, G in enumerate(graphs_list):
            cid = unique_clusters[i]
            # Relabel nodes to be unique across clusters if categories overlap between clusters
            # e.g., "gender=Male" in Cluster 1 vs "gender=Male" in Cluster 2
            mapping = {node: f"C{cid}_{node}" for node in G.nodes()}
            G_renamed = nx.relabel_nodes(G, mapping)
            
            # Add cluster attribute to nodes
            nx.set_node_attributes(G_renamed, cid, 'cluster_id')
            nx.set_node_attributes(G_renamed, f"Cluster {cid}", 'cluster_name')
            
            # Add cluster attribute to edges
            for u, v in G_renamed.edges():
                G_renamed[u][v]['cluster_id'] = cid
            
            super_G = nx.compose(super_G, G_renamed)
        
        nx.write_gexf(super_G, output_filename)
        print(f"Exported combined network with {len(unique_clusters)} clusters to {output_filename}")

    return graphs_list

# Usage Example:
# graphs = export_cluster_networks_to_gephi(df_clustered, categorical_cols, 'my_network.gexf')


def export_sep_cluster_networks_to_gephi_new(df_clustered, categorical_cols, output_filename='cluster_networks.gexf'):
    """
    Builds separate network components for each cluster and exports them 
    into a SINGLE GEXF file. 
    FIX: Attributes are now assigned ONLY to the specific cluster's nodes, preventing overwrites.
    """
    master_G = nx.Graph()
    
    # Prepare colors
    palette = plt.cm.tab10.colors
    var_color_map = {col: palette[i % len(palette)] for i, col in enumerate(categorical_cols)}

    unique_clusters = sorted(df_clustered['cluster'].unique())
    
    for cluster_id in unique_clusters:
        df_cl = df_clustered[df_clustered['cluster'] == cluster_id]
        n_persons = len(df_cl)

        # 1. Build Nodes and Edges data
        person_nodes = []
        for _, row in df_cl.iterrows():
            nodes = [f"C{cluster_id}_{col}={row[col]}" for col in categorical_cols]
            person_nodes.append(nodes)

        # Node frequency (Local to this cluster)
        node_freq = {}
        for nodes in person_nodes:
            for node in nodes:
                node_freq[node] = node_freq.get(node, 0) + 1

        # Edge frequency (Local to this cluster)
        edge_freq = {}
        for nodes in person_nodes:
            for a, b in itertools.combinations(sorted(nodes), 2):
                edge_freq[(a, b)] = edge_freq.get((a, b), 0) + 1

        # 2. Add Nodes and Edges to Master Graph
        master_G.add_nodes_from(node_freq.keys())
        for (a, b), w in edge_freq.items():
            master_G.add_edge(a, b, weight=w) # Temporary weight, will be overwritten with normalized one

        # 3. Assign Attributes (FIXED: Only for nodes in node_freq.keys())
        current_nodes = list(node_freq.keys())
        
        # Sizes
        sizes = {n: node_freq[n] * 30 for n in current_nodes}
        nx.set_node_attributes(master_G, sizes, 'size')
        
        # Colors
        colors = {}
        for node in current_nodes:
            original_node = node.split("_", 1)[1] 
            found_color = 'grey'
            for col, color_val in var_color_map.items():
                if original_node.startswith(f"{col}="):
                    r, g, b = color_val
                    hex_color = "#{:02x}{:02x}{:02x}".format(int(r*255), int(g*255), int(b*255))
                    found_color = hex_color
                    break
            colors[node] = found_color
        nx.set_node_attributes(master_G, colors, 'color')
        
        # Labels
        labels = {}
        for node in current_nodes:
            clean_node = node.split("_", 1)[1]
            label_text = clean_node.split("=", 1)[1]
            labels[node] = label_text
        nx.set_node_attributes(master_G, labels, 'label')
        
        # Metadata
        cluster_names = {n: f"Cluster {cluster_id}" for n in current_nodes}
        nx.set_node_attributes(master_G, cluster_names, 'cluster_group')
        cluster_ids = {n: cluster_id for n in current_nodes}
        nx.set_node_attributes(master_G, cluster_ids, 'cluster_id')

        # 4. Assign Edge Attributes (FIXED: Only for edges in edge_freq)
        # We iterate over the local edge_freq dictionary, not the whole graph
        weights = {}
        raw_counts = {}
        for (u, v), w in edge_freq.items():
            weights[(u, v)] = (w / n_persons * 10) if n_persons > 0 else 0
            raw_counts[(u, v)] = w
        
        nx.set_edge_attributes(master_G, weights, 'weight')
        nx.set_edge_attributes(master_G, raw_counts, 'co_occurrence_count')
        
        # Edge cluster metadata
        edge_clusters = { (u, v): cluster_id for (u, v) in edge_freq.keys() }
        nx.set_edge_attributes(master_G, edge_clusters, 'cluster_id')

    # 5. Export
    nx.write_gexf(master_G, output_filename)
    
    print(f"Exported {len(unique_clusters)} separate components to '{output_filename}'.")
    print("Note: Nodes are prefixed (C1_..., C2_...) to ensure no merging.")
    print("In Gephi: Run 'Force Atlas 2' to see them separate into distinct islands.")
    
    return master_G



def export_sep_cluster_networks_to_gephi(df_clustered, categorical_cols, output_filename='cluster_networks.gexf'):
    """
    Builds separate network components for each cluster and exports them 
    into a SINGLE GEXF file. Nodes are prefixed to prevent merging between clusters.
    """
    # Create a master graph to hold all disconnected components
    master_G = nx.Graph()
    
    # Prepare a color palette for variables (using tab10 like the original)
    palette = plt.cm.tab10.colors
    var_color_map = {col: palette[i % len(palette)] for i, col in enumerate(categorical_cols)}

    unique_clusters = sorted(df_clustered['cluster'].unique())
    
    for cluster_id in unique_clusters:
        df_cl = df_clustered[df_clustered['cluster'] == cluster_id]
        n_persons = len(df_cl)

        # 1. Build Nodes and Edges data
        person_nodes = []
        for _, row in df_cl.iterrows():
            # Create unique node IDs by prefixing with Cluster ID
            # Format: "C1_gender=Male"
            nodes = [f"C{cluster_id}_{col}={row[col]}" for col in categorical_cols]
            person_nodes.append(nodes)

        # Node frequency
        node_freq = {}
        for nodes in person_nodes:
            for node in nodes:
                node_freq[node] = node_freq.get(node, 0) + 1

        # Edge frequency
        edge_freq = {}
        for nodes in person_nodes:
            for a, b in itertools.combinations(sorted(nodes), 2):
                edge_freq[(a, b)] = edge_freq.get((a, b), 0) + 1

        # 2. Add Nodes and Edges to Master Graph
        # Since node names are now unique (prefixed), they won't merge with other clusters
        master_G.add_nodes_from(node_freq.keys())
        for (a, b), w in edge_freq.items():
            master_G.add_edge(a, b, weight=w)

        # 3. Assign Attributes for this Cluster's nodes
        
        # Sizes
        sizes = {n: node_freq[n] * 30 for n in node_freq.keys()}
        nx.set_node_attributes(master_G, sizes, 'size')
        
        # Colors (Extract original variable name from prefixed node "C1_var=val")
        colors = {}
        for node in node_freq.keys():
            # Strip "C1_" prefix to find the variable
            original_node = node.split("_", 1)[1] 
            found_color = 'grey'
            for col, color_val in var_color_map.items():
                if original_node.startswith(f"{col}="):
                    r, g, b = color_val
                    hex_color = "#{:02x}{:02x}{:02x}".format(int(r*255), int(g*255), int(b*255))
                    found_color = hex_color
                    break
            colors[node] = found_color
        nx.set_node_attributes(master_G, colors, 'color')
        
        # Labels (Strip "C1_" and "variable=" to show only value)
        labels = {}
        for node in node_freq.keys():
            # Remove prefix "C1_"
            clean_node = node.split("_", 1)[1]
            # Remove "variable="
            label_text = clean_node.split("=", 1)[1]
            labels[node] = label_text
        nx.set_node_attributes(master_G, labels, 'label')
        
        # Metadata: Store which cluster this node belongs to
        cluster_names = {n: f"Cluster {cluster_id}" for n in node_freq.keys()}
        nx.set_node_attributes(master_G, cluster_names, 'cluster_group')
        cluster_ids = {n: cluster_id for n in node_freq.keys()}
        nx.set_node_attributes(master_G, cluster_ids, 'cluster_id')

        # 4. Assign Edge Attributes
        weights = {}
        raw_counts = {}
        for u, v in master_G.edges():
            # Only process edges belonging to this cluster (they share the C{ID} prefix)
            if u.startswith(f"C{cluster_id}_"):
                w = edge_freq.get((u, v), edge_freq.get((v, u), 0))
                weights[(u, v)] = (w / n_persons * 10) if n_persons > 0 else 0
                raw_counts[(u, v)] = w
        
        nx.set_edge_attributes(master_G, weights, 'weight')
        nx.set_edge_attributes(master_G, raw_counts, 'co_occurrence_count')
        
        # Edge cluster metadata
        edge_clusters = { (u, v): cluster_id for u, v in master_G.edges() if u.startswith(f"C{cluster_id}_") }
        nx.set_edge_attributes(master_G, edge_clusters, 'cluster_id')

    # 5. Export Single File
    # The resulting file will have multiple disconnected "islands" (components)
    nx.write_gexf(master_G, output_filename)
    
    print(f"Successfully exported {len(unique_clusters)} separate components to '{output_filename}'.")
    print("In Gephi: Use 'Statistics' > 'Connected Components' to verify isolation.")
    
    return master_G

# Usage:
# G_all = export_cluster_networks_to_gephi(df_clustered, categorical_cols, 'separate_clusters.gexf')