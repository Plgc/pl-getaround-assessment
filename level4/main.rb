#!/usr/bin/env ruby
#coding:utf-8

#Requirements
require('sinatra')
require('logger')
require('json')

require_relative('./src/RedisHandler')
require_relative('./src/Parser')
#require_relative('./slow_computation.rb')

# Server App Configuration
set :bind, '0.0.0.0'
set :port, 3000
set :run, true
set :logging, Logger::ERROR
set :server_settings, threaded: true

# Global App Configuration
RES_PATH="parsed"
REDDIS_HOST="localhost"
REDDIS_PORT=6379
REDDIS_LIST="temp_logs"


# Main function of the app.
# Parse logs posted on /
# into a list in a given Redis list
#
# === Example
# Will parse a payload posted on '/'
# {"log"=>"id=5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81 service_name=web process=web.806 sample#load_avg_1m=0.988 sample#load_avg_5m=0.15 sample#load_avg_15m=0.898"}
# into a redis base REDDIS_HOST:REDDIS_PORT in a redis list REDDIS_LIST
# with value
#{
#  "id": "5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81",
#  "service_name": "web",
#  "process": "web.806",
#  "load_avg_1m": "0.988",
#  "load_avg_5m": "0.15",
#  "load_avg_15m": "0.898"
#}
def main()

  begin
    redis=RedisHandler.new(REDDIS_HOST,REDDIS_PORT,REDDIS_LIST)
  rescue Redis::BaseError => e
    puts e.inspect
    exit 1
  end

  get '/' do
      'Usage: post payload on / <br/> Example: post {"log"=>"id=5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81 service_name=web process=web.806 sample#load_avg_1m=0.988 sample#load_avg_5m=0.15 sample#load_avg_15m=0.898"} on /'
  end

  post '/' do
    begin
      body = JSON.parse(request.body.read)
      logger.debug body
      uuid = Parser.extract_uuid(body['log'])
      data = Parser.parse([body['log']])
      logger.debug data
      #data = SlowComputation.new(data).compute()
      redis.add_to_list(data)
      logger.debug data
      status 200
    rescue ArgumentError => e
      logger.error'Error: ArgumentError in method call'
      print_exception(e, true)
      status 500
    rescue IndexError => e
      logger.error 'Error: wrong format in payload : '+body
      status 400
      next
    rescue Redis::BaseError => e
      e.inspect
      status 500
      next
    end
  end
end

main()
