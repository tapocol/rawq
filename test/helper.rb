require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'rr'
require "mongoid"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("test_rawq")
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rawq'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  def teardown
    Mongoid.master.connection.drop_database("test_rawq")
  end
end

