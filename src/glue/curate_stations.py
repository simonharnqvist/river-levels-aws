from pyspark.sql import functions as F
import sys
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.job import Job
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ["JOB_NAME", "raw_bucket", "curated_bucket"])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

raw_path = f"s3://{args['raw_bucket']}/raw/stations/"
curated_path = f"s3://{args['curated_bucket']}/curated/stations"


df = spark.read.json(raw_path)

stations = df.select(F.col("station_id"), F.col("station_name"), F.col("river")).filter(
    F.col("river").isNotNull()
)

stations.write.mode("overwrite").parquet(curated_path)

job.commit()
