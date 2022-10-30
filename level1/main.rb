#!/usr/bin/env ruby
#coding:utf-8

# Requirements

require "./src/Parser.rb"
require "./src/FileHandler.rb"

# Config

LOGS_PATH="logs"
RES_PATH="parsed"


# Main function of the app.
# Process logs files located in dir LOGS_PATH
# into formated CSV output into dir RES_PATH
#
# === Example
# Will transform a file logs/0060cd38-9dd5-4eff-a72f-9705f3dd25d9.txt containing
# id=0060cd38-9dd5-4eff-a72f-9705f3dd25d9 service_name=api process=api.233 sample#load_avg_1m=0.849 sample#load_avg_5m=0.561 sample#load_avg_15m=0.202
# into the file parsed/0060cd38-9dd5-4eff-a72f-9705f3dd25d9.json
# containing
#{
#    "id": "2acc4f33-1f80-43d0-a4a6-b2d8c1dbbe47",
#    "service_name": "web",
#    "process": "web.1089",
#    "load_avg_1m": "0.04",
#    "load_avg_5m": "0.10",
#    "load_avg_15m": "0.31"
#  }
def main()
    if File.directory?(LOGS_PATH)
        FileHandler.create_folder(RES_PATH)
        Dir.glob(LOGS_PATH+"/*.txt") do |logs_file|
            begin
                uuid = Parser.extract_uuid(LOGS_PATH,logs_file)
                raw_data = FileHandler.get_lines(logs_file)
                data = Parser.parse(raw_data)
                res_file = FileHandler.create_file(RES_PATH+'/'+uuid+'.json',data)
                FileHandler.delete_file(logs_file) if File.exists?(res_file)

            rescue ArgumentError => e
                STDERR.puts 'Error: ArgumentError in method call'
                print_exception(e, true)
            rescue IndexError => e
                STDERR.puts 'Error: wrong format in : '+logs_file
                next
            rescue Errno::ENOENT => e
                STDERR.puts 'Error: could not open or delete file : '+logs_file
                next
            rescue Errno::EEXIST => e
                STDERR.puts 'Error: file allready exists: '+ RES_PATH+'/'+uuid+'.json'
                next
            end
        end
    else
        STDERR.puts('Error : Log directory not found : '+LOGS_PATH)
        exit 1
    end
end

main()
