import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import split, count, explode


# export SRC_DIR=/user/`whoami`/randomtextwriter
# export TGT_DIR=/user/`whoami`/word_count

src_dir = os.environ.get('SRC_DIR')
tgt_dir = os.environ.get('TGT_DIR')

spark = SparkSession. \
    builder. \
    appName('WORD count').\
    master('yarn'). \
    getOrCreate()

lines = spark.read.text(src_dir)

words =lines.select(explode(split('value',' ')).alias('word'))
word_counts = words .\
    groupBy('word'). \
    agg(count('*').alias('word_count'))

word_counts. \
    write. \
    mode('overwrite'). \
    csv(tgt_dir)