import pandas as pd 
import os

dataset_from_HDFS = 'HDFS_BVB_Dataset.csv'

df = pd.read_csv(dataset_from_HDFS)
df = df[df["Symbol"] != "Symbol"]

df.to_csv('BVB_Dataset.csv', index=False) 

if os.path.isfile(dataset_from_HDFS):
    os.remove(dataset_from_HDFS)