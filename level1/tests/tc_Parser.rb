require_relative "../src/Parser"
require "test/unit"

# Unit Tests for Parser class
class TestParser < Test::Unit::TestCase

  def test_extract_uuid
    assert_equal("0a2f0f86-de73-4526-aa3c-83e31eab6da1", Parser.extract_uuid("parsed","parsed/0a2f0f86-de73-4526-aa3c-83e31eab6da1.txt") )
    assert_equal("parsed/0a2f0f86-de73-4526-aa3c-83e31eab6da1", Parser.extract_uuid("","parsed/0a2f0f86-de73-4526-aa3c-83e31eab6da1.txt") )
    assert_raise( ArgumentError ) { Parser.extract_uuid(nil,"parsed/0a2f0f86-de73-4526-aa3c-83e31eab6da1.txt") }
    assert_raise( ArgumentError ) { Parser.extract_uuid("parsed",nil) }
    assert_raise( ArgumentError ) { Parser.extract_uuid("parsed","") }
  end

  def test_parse
    test_array = ['id=0a1c7133-708e-40cf-8123-a441c3f3df43 service_name=admin process=admin.2983 sample#load_avg_1m=0.583 sample#load_avg_5m=0.404 sample#load_avg_15m=0.738']
    test_map = {
    "id" => "0a1c7133-708e-40cf-8123-a441c3f3df43",
    "service_name" => "admin",
    "process" => "admin.2983",
    "load_avg_1m"=> "0.583",
    "load_avg_5m"=> "0.404",
    "load_avg_15m" => "0.738"
    }

    assert_equal(JSON.pretty_generate(test_map), Parser.parse(test_array))
    assert_equal("", Parser.parse([""]))
    assert_raise( ArgumentError ) { Parser.parse(nil)}

  end


  def test_clean_words
    assert_equal([],Parser.clean_words([]))
    test_array = ['id=0a1c7133-708e-40cf-8123-a441c3f3df43','service_name=admin', 'process=admin.2983','sample#load_avg_1m=0.583','sample#load_avg_5m=0.404', 'sample#load_avg_15m=0.738']
    test_array_output = ['0a1c7133-708e-40cf-8123-a441c3f3df43','admin', 'admin.2983','0.583','0.404', '0.738']
    assert_equal(test_array_output,Parser.clean_words(test_array))
    assert_raise( ArgumentError ) { Parser.clean_words(nil)}
  end

  def test_format_json
    assert_equal("",Parser.format_json([]))
    test_array = ['0a1c7133-708e-40cf-8123-a441c3f3df43','admin', 'admin.2983','0.583','0.404', '0.738']
    test_json = JSON.pretty_generate({
      "id" => "0a1c7133-708e-40cf-8123-a441c3f3df43",
      "service_name" => "admin",
      "process" => "admin.2983",
      "load_avg_1m"=> "0.583",
      "load_avg_5m"=> "0.404",
      "load_avg_15m" => "0.738"
      })
    assert_equal(test_json,Parser.format_json(test_array))
    assert_raise( ArgumentError ) { Parser.format_json(nil)}
  end

end
