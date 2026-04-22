
### Functions used in bivariate analysis

import pandas as pd
import numpy as np
import scipy.stats as stats
import statsmodels.api as sm

import matplotlib.pyplot as plt
import seaborn as sns


def bivariate_stats(observed: pd.DataFrame) -> pd.DataFrame:

    ### observed : contingency table without totals in margins


    ### Valeurs produites par la fonction de la librairie 'stats'
    statistic, p, dof, expected = stats.chi2_contingency(observed)

    print('Chi-square :', statistic.round(2), ', dof :',dof)
    print('p-value :', p.round(3))

    
    ## Phi-square coefficient = inertia
    phi_2=statistic/observed.sum().sum()
    print('Inertia (Phi-square): ', phi_2.round(3))

    ### Coéfficient de Cramer
    vc = stats.contingency.association(observed, method='cramer')
    print('Cramer: ', round(vc, 3))

    ## the returned expected contingency table can be stored in a variable and used in a function
    return expected



## test if expected contingency table follows the rules for validity of Chi-square test

def check_chi_square_test_validity(observed: pd.DataFrame) -> bool:
    """
    Validates a contingency table based on two criteria:
    1. No cell has a value less than 1.
    2. Not more than 20% of cells have values less than or equal to 5.
    
    Parameters:
    contingency_df (pd.DataFrame): The contingency table.
    
    Returns:
    bool: True if both conditions are met, False otherwise.
    """


    # Get expected contingency table
    statistic, p, dof, expected = stats.chi2_contingency(observed)
    
    # Condition 1: No cell has a value less than 1
    # min().min() gets the global minimum of the dataframe
    min_val = expected.min().min()
    condition_1 = min_val >= 1
    
    # Condition 2: Not more than 20% of cells have values <= 5
    total_cells = expected.size
    if total_cells == 0:
        return False # Or True, depending on how you define empty tables
        
    cells_le_5 = (expected <= 5).sum().sum()
    percent_le_5 = cells_le_5 / total_cells
    
    condition_2 = percent_le_5 <= 0.20

    # result : True or False
    result=condition_1 and condition_2
    
    return print(f"Table valid for Chi-square test: {result}")




### ct_m : contingency tables with totals in margins
def plot_chi2_residuals(observed, figsize=(9,3)):
    
    ### Get signed resitduals using statmodels (sm)

    # 1. Create the Table object directly from your data
    table = sm.stats.Table(observed)
    
    # 2. Get Adjusted Residuals instantly (no manual formula needed)
    adjusted_resids = table.standardized_resids
    adjusted_resids.round(1)
   

    fig, ax = plt.subplots(figsize=figsize)         
    
    # Create heatmap
    sns.heatmap(
        adjusted_resids.round(1), 
        annot=True,            # Use boolean True to annotate with data values
        cmap="coolwarm", 
        linewidths=.5, 
        ax=ax,
        cbar_kws={'label': 'Residuals'}
    )
    # 3. Fix Label Rotation (Safe Method)
    # This rotates existing ticks without risking a count mismatch
    ax.set_xticklabels(ax.get_xticklabels(), rotation=80, ha='right')
    ax.set_yticklabels(ax.get_yticklabels(), rotation=20, va='center')
    ax.set_title("Adjusted Residual", fontsize=12)
    
    # ax.set_title("Heatmap of Adjusted Residuals (via statsmodels)")
    plt.tight_layout()
    plt.show()