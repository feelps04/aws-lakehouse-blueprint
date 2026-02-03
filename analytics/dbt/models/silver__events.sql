-- Blueprint: in a real project, this would read from Silver parquet via Athena/Glue catalog.
-- Here we keep it generic for demonstration.
select
  cast(event_id as varchar) as event_id,
  cast(user_key as varchar) as user_key,
  cast(feature_a as varchar) as feature_a,
  cast(value_amount as double) as value_amount,
  try(from_iso8601_timestamp(event_timestamp)) as event_ts,
  cast(geo_country as varchar) as geo_country,
  cast(device_type as varchar) as device_type
from {{ source('silver', 'events') }}
