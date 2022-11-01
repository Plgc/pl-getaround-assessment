# Level 4

## Summary

The level4 program is the same as level2 and level3.

## Instructions

Write a simple HTTP server that serves the requests, parse and "enrich" the logs, and store them into a Redis `LIST` on a local Redis instance.

The log "enrichment" is done using the provided `SlowComputation` module.

**BEWARE** This module is pretty slow and the level4 program enforces a 100ms timeout.

Please include a short explanation (<200 words) that highlights some of the advantages and shortcommings of your approach.


## How to use `SlowComputation`

```rb
require "slow_computation"

new_json = SlowComputation.new(your_json).compute
```

eg:
```json
{
  "id": "2acc4f33-1f80-43d0-a4a6-b2d8c1dbbe47",
  "service_name": "web",
  "process": "web.1089",
  "load_avg_1m": "0.04",
  "load_avg_5m": "0.10",
  "load_avg_15m": "0.31",
  "slow_computation": "0.0009878"
 }
```

## Approach

1) Increase the connection pool : not reliable
2) Threading the long computation : not reliable

3) Use a queue : all the posted messages are queued (in a folder, a Redis list or a Kafka ?) and computed asynchronously --> solve the timeout issue but need of a temp queue.
Also needs two differents scripts (could have been done by running the second in a Thread):
- the first is main.rb, the http server which collects the logs and insert it in a temp queue (=a temps Redis list)
- the second is compute.rb, the one computing the logs in the temp queue and inserting it in the final Redis List

## Usage
1) run main.rb
2) run compute.rb
3) run level4

