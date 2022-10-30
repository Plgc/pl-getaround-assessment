#coding:utf-8

require 'json'

# class with all actions on the text data
class Parser

    # Extract the uuid from the filename
    #
    # ==== Attributes
    #
    # * +directory+ - The path of the directory where the files are - str - not nil
    # * +full_path+ - The full path to the file - str  - not nil nor empty  #
    #
	# ==== Outputs
    #
    # * +uuid+ - The extracted uuid - str
	#
    def self.extract_uuid(directory,full_path)
        if directory.nil? || full_path.nil? || full_path.empty?
            raise ArgumentError.new("ArgumentError : check value of directory or full_path ")
        end
        return full_path[directory.length+1..-5] if directory.length !=0 # ignoring directory and extension to extract uuid
        return full_path[0..-5]

    end

    # main function to parse a text (as an array of lines) into JSON
    #
    # ==== Attributes
    #
    # * +lines+ - Array of the lines - [str] - not nil
    #
	# ==== Outputs
    #
    # * +result+ - data formated as JSON - str
	#
    def self.parse(lines)
        if lines.nil?
            raise ArgumentError.new("ArgumentError : check value of lines ")
        end
        result=""
        lines.each do |line|
            cleaned_word=self.clean_words(line.split)
            result+=self.format_json(cleaned_word)
        end
        return result
    end

    # 'Cleans up' every word from a list
    # removes every char before the '=' sign
    #
    # ==== Attributes
    #
    # * +array+ - Array of the words - [str] - not nil
    #
	# ==== Outputs
    #
    # * +res+ - Array of the cleaned words - [str]
	#
    def self.clean_words(array)
        if array.nil?
            raise ArgumentError.new("ArgumentError : check value of array ")
        end
        res=[]
        array.each do |value|
            value=value[value.index('=')+1..] if value.include? '='
            res+=[value]
        end
        return res
    end

    # Formats a list of word into the wanted JSON output
    #
    # ==== Attributes
    #
    # * +array+ - Array of the words - [str] - not nil
    #
	# ==== Outputs
    #
    # * +res+ - formated Json output - str
	#
    def self.format_json(array)
        if array.nil?
            raise ArgumentError.new("ArgumentError : check value of array ")
        end
        return "" if array.length == 0
        if array.length != 6
            raise IndexError.new("Wrong text format")
        end
        map = {
            "id" => array[0],
            "service_name"=> array[1],
            "process"=> array[2],
            "load_avg_1m"=> array[3],
            "load_avg_5m"=> array[4],
            "load_avg_15m"=> array[5]
        }

        return JSON.pretty_generate(map)
    end

end
