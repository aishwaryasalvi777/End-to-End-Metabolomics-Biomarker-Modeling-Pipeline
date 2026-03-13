import pandas as pd
from .config import PLACENTA_FILE, NORMALIZED_SHEET

def load_placenta_normalized():
    """Task 1: Load 4th sheet 'Normalized data'"""
    return pd.read_excel(PLACENTA_FILE, sheet_name=NORMALIZED_SHEET)

def load_cord_normalized():
    """Load cord blood Normalized data sheet"""
    from .config import CORD_FILE, CORD_NORMALIZED_SHEET
    return pd.read_excel(CORD_FILE, sheet_name=CORD_NORMALIZED_SHEET)


def save_csv(df, filepath, index=False):
    """Save DataFrame to CSV, overwriting if file exists"""
    df.to_csv(filepath, index=index, mode='w')