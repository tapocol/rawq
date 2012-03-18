require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/autorun'
require 'rr'
require "mongoid"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("test_rawq")
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rawq'

class MiniTest::Spec
  include RR::Adapters::MiniTest
  before do
    # TODO: Refactor to factories.
    @medias = [RawQ::Media.new, RawQ::Media.new]
    @medias[0].media_type = "audio"
    @medias[0].sources = [RawQ::Source.new, RawQ::Source.new]
    @medias[0].sources[0].file = File.join(File.dirname(__FILE__), 'media', 'source.mp3')
    @medias[0].sources[0].filename = 'source.mp3'
    @medias[0].sources[0].mimetype = 'audio/mpeg'
    @medias[0].sources[1].file = File.join(File.dirname(__FILE__), 'media', 'source-nofile.mp3')
    @medias[0].sources[1].filename = 'source2.mp3'
    @medias[0].sources[1].mimetype = 'audio/mpeg'
    @medias[1].media_type = "video"
    @medias[1].sources = [RawQ::Source.new]
    @medias[1].sources[0].file = File.join(File.dirname(__FILE__), 'media', 'source-nofile.mp3')
    @medias[1].sources[0].filename = 'source3.mp3'
    @medias[1].sources[0].mimetype = 'audio/mpeg'
    stub(RawQ::Media).find("1234") { @medias[0] }
    stub(RawQ::Media).find("zxcv") { raise BSON::InvalidObjectId.new }
    stub(RawQ::Media).find { raise Mongoid::Errors::DocumentNotFound.new(RawQ::Media, []) }
    stub(RawQ::Media).all { [RawQ::Media.new, RawQ::Media.new] }
    stub(@medias[0].sources).find("5678") { @medias[0].sources[0] }
    stub(@medias[0].sources).find("zxcv") { raise BSON::InvalidObjectId.new }
    stub(@medias[0].sources).find { raise Mongoid::Errors::DocumentNotFound.new(RawQ::Source, []) }
  end

  after do
    Mongoid.master.connection.drop_database("test_rawq")
  end
end

