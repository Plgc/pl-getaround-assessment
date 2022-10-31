#coding:utf-8

# A class for all action on files.
class FileHandler

	# create a file with given path and data
    #
    # ==== Attributes
    #
    # * +full_path+ - The full path to the file - str - not nil nor empty
	# * +json_data+ - The data to insert in the file - str - not nil
    #
	# ==== Outputs
    #
    # * +full_path+ - The full path to the file - str
	#
    def self.create_file(full_path,json_data)
		if full_path.nil?  || full_path.empty? || json_data.nil?
            raise ArgumentError.new("ArgumentError : check value of full_path or json_data")
        end
		File.open(full_path, 'w') {|f| f.write(json_data)}
      	return full_path
    end

	# Creates a dir a the given path
	# Ignores it if the directory allready exists
    #
    # ==== Attributes
    #
    # * +path+ - The path and name of the directory - str - not nil nor empty
    #
	# ==== Outputs
    #
    # None
	#
    def self.create_folder(path)
		if path.nil?  || path.empty?
            raise ArgumentError.new("ArgumentError : check value of path")
        end
      	Dir.mkdir(path) unless File.exists?(path)
    end


end
