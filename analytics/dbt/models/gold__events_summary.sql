select
  date_trunc('day', event_ts) as event_day,
  feature_a,
  count(*) as events_count,
  sum(value_amount) as value_amount_sum
from {{ ref('silver__events') }}
group by 1, 2
