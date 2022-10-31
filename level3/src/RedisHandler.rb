#coding:utf-8
require 'redis'

# class with all actions on the redis server
class RedisHandler

  @connexion=nil

  # Create the connexion with the redis database
  # And test the connexion (raise Redis::CannotConnectError if the connexion fails)
  #
  # ==== Attributes
  #
  # * +host+ - The hostname of the Redis server - str
  # * +port+ - The port of the Redis server  - str
  # * +list_name+ - The list name where the data will be recorded on the Redis server - str
  #
	# ==== Outputs
  #
  # * +connexion+ - The Redis connector - Redis
	#
  def initialize(host='localhost',port=6379,list_name='logs')
    @host = host
    @port = port
    @list_name  = list_name
    @connexion = Redis.new(host: @host, port: @port)
    @connexion.ping() # test if the connexion works
    return @connexion
  end

  # add the given data (str) to the list on the Redis server
  #
  # ==== Attributes
  #
  # * +data+ - The data to add on the Redis server - str
  #
	# ==== Outputs
  #
  # None
	#
  def add_to_list(data)
    if data.nil?  || data.empty?
      raise ArgumentError.new("ArgumentError : check value of data")
    end
    if @connexion.nil?
      raise Redis::CannotConnectError.new("you have to create a new RedisHandler instance first")
    end
    @connexion.lpush(@list_name,data)
  end
end
