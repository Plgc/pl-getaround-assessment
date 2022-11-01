require_relative "../src/RedisHandler"
require "test/unit"
require "redis"


# Unit Tests for RedisHandler class
# a running Redis server on localhost:6379 is required to pass the tests
class TestRedisHandler < Test::Unit::TestCase

  def test_initialize
    assert_raise( Redis::CannotConnectError ) { RedisHandler.new("hostname",1,"list") }
    #assert_instance_of(RedisHandler,RedisHandler.new("localhost", 6379) )
  end


  def test_add_to_list
    $redis = RedisHandler.new
    assert_raise( ArgumentError ) { $redis.add_to_list("") }
    assert_raise( ArgumentError ) { $redis.add_to_list(nil) }
    assert_nothing_raised( Redis::BaseError) {$redis.add_to_list("sample data")}
  end

  def test_pop_from_list
    #redis = RedisHandler.new
    assert_raise( ArgumentError ) { $redis.pop_from_list("") }
    assert_raise( ArgumentError ) { $redis.pop_from_list(nil) }
    assert_nothing_raised( Redis::BaseError) {$redis.pop_from_list("test_list")}
  end


end
