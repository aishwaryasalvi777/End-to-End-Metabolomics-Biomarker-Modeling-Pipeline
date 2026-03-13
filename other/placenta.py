import pandas as pd
import numpy as np
import os

# Set working directory
data_dir = '/Users/aishvarya/Library/CloudStorage/OneDrive-UniversityatBuffalo/Desktop/Project/Metabolomics/data'
os.chdir(data_dir)

# Load the MetaPro Placenta dataset
# print("Loading MetaPro Placenta dataset...")
placenta_file = 'MetaPro_placenta_Jan2022.xlsx'
placenta_df = pd.read_excel(placenta_file)

print("\n" + "="*80)
print("PLACENTA DATASET OVERVIEW")
print("="*80)
print(f"\nDataset shape: {placenta_df.shape}")
print(f"Rows (samples): {placenta_df.shape[0]}")
print(f"Columns (total): {placenta_df.shape[1]}")

print("\n" + "-"*80)
print("Column Names and Data Types:")
print("-"*80)
for idx, col in enumerate(placenta_df.columns, 1):
    print(f"{idx}: {col} - {placenta_df[col].dtype}")

print("\n" + "-"*80)
print("First few rows:")
print("-"*80)
print(placenta_df.head())

print("\n" + "-"*80)
print("Data sample from each section:")
print("-"*80)
print("\nFirst 3 columns (A, B, C):")
print(placenta_df.iloc[:3, :3])
print("\nColumns around K (annotation end):")
print(placenta_df.iloc[:3, 8:13] if placenta_df.shape[1] > 12 else placenta_df.iloc[:3, 8:])
print("\nColumns around L (data start):")
print(placenta_df.iloc[:3, 11:16] if placenta_df.shape[1] > 15 else placenta_df.iloc[:3, 11:])
