from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_timestamp

# NOTE: Blueprint job with generic columns (no business logic)


def main():
  spark = SparkSession.builder.appName("bronze-to-silver-blueprint").getOrCreate()

  bronze_path = spark.conf.get("spark.lakehouse.bronze_path")
  silver_path = spark.conf.get("spark.lakehouse.silver_path")

  df = spark.read.json(bronze_path)

  required_cols = {
    "event_id",
    "event_timestamp",
    "user_key",
    "feature_a",
    "value_amount",
  }

  missing = sorted(list(required_cols - set(df.columns)))
  if missing:
    raise ValueError(f"Schema validation failed. Missing required columns: {missing}")

  typed = (
    df.select(
      col("event_id").cast("string").alias("event_id"),
      col("event_timestamp").cast("string").alias("event_timestamp"),
      col("user_key").cast("string").alias("user_key"),
      col("feature_a").cast("string").alias("feature_a"),
      col("value_amount").cast("double").alias("value_amount"),
      col("geo_country").cast("string").alias("geo_country"),
      col("device_type").cast("string").alias("device_type"),
      col("metadata")
    )
  )

  cleaned = (
    typed.withColumn("event_ts", to_timestamp(col("event_timestamp")))
      .dropna(subset=["event_id", "event_timestamp"])
  )

  (cleaned
    .repartition(1)
    .write
    .mode("append")
    .parquet(silver_path)
  )

  spark.stop()


if __name__ == "__main__":
  main()
