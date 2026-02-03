import argparse
import json
import os
import random
from datetime import datetime, timezone

import boto3
from faker import Faker


def make_event(fake: Faker) -> dict:
  return {
    "event_id": fake.uuid4(),
    "event_timestamp": datetime.now(timezone.utc).isoformat(),
    "user_key": fake.uuid4(),
    "feature_a": random.choice(["search", "click", "subscribe", "purchase"]),
    "value_amount": round(random.uniform(0, 9999.99), 2),
    "geo_country": fake.country_code(),
    "device_type": random.choice(["mobile", "desktop", "tablet"]),
    "metadata": {
      "source": random.choice(["web", "api", "partner"]),
      "campaign": fake.word(),
    },
  }


def main() -> None:
  parser = argparse.ArgumentParser()
  parser.add_argument("--bucket", required=True)
  parser.add_argument("--prefix", required=True)
  parser.add_argument("--rows", type=int, default=1000)
  args = parser.parse_args()

  fake = Faker()

  events = [make_event(fake) for _ in range(args.rows)]
  payload = "\n".join(json.dumps(e, ensure_ascii=False) for e in events) + "\n"

  key = os.path.join(args.prefix.rstrip("/"), f"events_{datetime.utcnow().strftime('%Y%m%dT%H%M%SZ')}.jsonl")

  s3 = boto3.client("s3")
  s3.put_object(
    Bucket=args.bucket,
    Key=key,
    Body=payload.encode("utf-8"),
    ContentType="application/json",
  )

  print(f"Uploaded {args.rows} rows to s3://{args.bucket}/{key}")


if __name__ == "__main__":
  main()
