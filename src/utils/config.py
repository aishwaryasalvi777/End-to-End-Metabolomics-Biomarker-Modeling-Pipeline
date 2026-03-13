import os

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT_DIR, "raw")
PROCESSED_DIR = os.path.join(ROOT_DIR, "processed_data")
OUTPUTS_DIR = os.path.join(ROOT_DIR, "../outputs")

##  ******** PCA File Paths  ********
PCA_DIR = os.path.join(OUTPUTS_DIR, "pca")
PCA_IMAGE_DIR = os.path.join(PCA_DIR, "output_images")
PCA_CSV_DIR = os.path.join(PCA_DIR, "output_csv")

##  ******** Placenta File Paths  ********
PLACENTA_FILE = os.path.join(RAW_DIR, "MetaPro_placenta_Jan2022.xlsx")
NORMALIZED_SHEET = "Normalized data"

PLACENTA_ANNO = os.path.join(PROCESSED_DIR, "placenta", "Met_ana_placenta.csv")
PLACENTA_DATA = os.path.join(PROCESSED_DIR, "placenta", "Met_data_placenta.csv")
PLACENTA_DATA_T = os.path.join(PROCESSED_DIR, "placenta", "Met_data_placenta_T.csv")


#  ******** Cord paths  ********
CORD_FILE = os.path.join(RAW_DIR, "MetaPro_cord_blood_Jan2022.xlsx")
CORD_NORMALIZED_SHEET = "Normalized data"  

CORD_ANNO = os.path.join(PROCESSED_DIR, "cord", "Met_ana_cord.csv")
CORD_DATA = os.path.join(PROCESSED_DIR, "cord", "Met_data_cord.csv")
CORD_DATA_T = os.path.join(PROCESSED_DIR, "cord", "Met_data_cord_T.csv")
