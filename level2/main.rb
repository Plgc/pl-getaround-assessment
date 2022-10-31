#!/usr/bin/env ruby
#coding:utf-8

#Requirements
require('sinatra')
require('logger')
require('json')

require_relative('./src/FileHandler')
require_relative('./src/Parser')

# App Configuration
set :bind, '0.0.0.0'
set :port, 3000
set :run, true
set :logging, Logger::ERROR
RES_PATH="parsed"


# Main function of the app.
#
# into formated CSV output into dir RES_PATH
#
# === Example
# Will transform a paylog posted on '/'
# {"log"=>"id=5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81 service_name=web process=web.806 sample#load_avg_1m=0.988 sample#load_avg_5m=0.15 sample#load_avg_15m=0.898"}
# into the file parsed/5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81.json
# containing
#{
#  "id": "5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81",
#  "service_name": "web",
#  "process": "web.806",
#  "load_avg_1m": "0.988",
#  "load_avg_5m": "0.15",
#  "load_avg_15m": "0.898"
#}
def main()

  get '/' do
      'Usage: post payload on / <br/> Example: post {"log"=>"id=5cc9b9a6-ab53-4c6a-9f13-c9b4860e6c81 service_name=web process=web.806 sample#load_avg_1m=0.988 sample#load_avg_5m=0.15 sample#load_avg_15m=0.898"} on /'
  end

  post '/' do
    begin
      FileHandler.create_folder(RES_PATH)
      body = JSON.parse(request.body.read)
      logger.debug body
      uuid = Parser.extract_uuid(body['log'])
      data = Parser.parse([body['log']])
      logger.debug data
      res_file = FileHandler.create_file(RES_PATH+'/'+uuid+'.json',data)
    rescue ArgumentError => e
      logger.error'Error: ArgumentError in method call'
      print_exception(e, true)
    rescue IndexError => e
      logger.error 'Error: wrong format in payload : '+body
      next
    rescue Errno::EEXIST => e
      logger.error 'Error: file allready exists: '+ RES_PATH+'/'+uuid+'.json'
      next
    end
  end
end

main()
