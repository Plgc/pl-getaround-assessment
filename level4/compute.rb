#!/usr/bin/env ruby
#coding:utf-8

#Requirements
require('logger')
require('json')
require ('logger')

require_relative('./src/RedisHandler')
require_relative('./slow_computation.rb')

# Global App Configuration
REDDIS_HOST="localhost"
REDDIS_PORT=6379
REDDIS_TEMP_LIST="temp_logs"
REDDIS_LIST="logs"

# Logger Configuration
$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG


# Main function of the app.
# compute logs from a temporary Redis List and add the result to the final Redis List
#
# === Example
# {
#  "id": "24ae7632-8acf-479b-8410-429cc99b6ccc",
#  "service_name": "web",
#  "process": "web.2321",
#  "load_avg_1m": "0.128",
#  "load_avg_5m": "0.155",
#  "load_avg_15m": "0.353"
#}
#into
#{"id":"7ccf970c-4d27-47db-ad1a-ac5ae71426ed","service_name":"api","process":"api.2629","load_avg_1m":"0.959","load_avg_5m":"0.009","load_avg_15m":"0.381","slow_computation":"0.0009878"}
def main()
  begin
    redis=RedisHandler.new(REDDIS_HOST,REDDIS_PORT,REDDIS_LIST)
  rescue Redis::BaseError => e
    puts e.inspect
    exit 1
  end

  while true
    begin
      data = redis.pop_from_list(REDDIS_TEMP_LIST)
      if !data.nil?
        $logger.debug("starting computation of :"+data)
        data = SlowComputation.new(data).compute()
        $logger.debug("Compute result :"+data)
        redis.add_to_list(data)
      else
        $logger.info("No logs found to compute in temp queue, waiting...")
        sleep 10
      end
    rescue ArgumentError => e
      $logger.error('Error: ArgumentError in method call')
      print_exception(e, true)
    rescue Redis::BaseError => e
      $logger.error("Error: couldn't add data to Redis list :"+data)
      e.inspect
      next
    end

  end
end

main()
