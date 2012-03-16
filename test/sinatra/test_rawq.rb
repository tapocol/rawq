require "helper"
require "sinatra/base"
require "rack/test"

class TestApp < Sinatra::Base
  register Sinatra::RawQExt
  set :username, "testuser"
  set :password, "testpass"
  set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')
  set :views, File.join(File.dirname(__FILE__), '..', 'views')
end

class SinatraRawQExtTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp
  end

  context "registered" do
    context "get /" do
      should "respond unauthorized status when missing credentials" do
        get "/"
        assert_equal 401, last_response.status
      end

      should "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/"
        assert_equal 401, last_response.status
      end

      should "respond ok status when correct credentials" do
        authorize "testuser", "testpass"
        get "/"
        assert_equal 200, last_response.status
      end
    end

    context "get /media" do
      should "respond unauthorized status when missing credentials" do
        get "/media"
        assert_equal 401, last_response.status
      end

      should "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media"
        assert_equal 401, last_response.status
      end

      should "respond ok status when correct credentials" do
        authorize "testuser", "testpass"
        get "/media"
        assert_equal 200, last_response.status
      end
    end

    context "get /media/:id" do
      setup do
        @media = RawQ::Media.create :media_type => "audio"
      end

      should "respond unauthorized status when missing credentials" do
        get "/media/#{@media.id}"
        assert_equal 401, last_response.status
      end

      should "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/#{@media.id}"
        assert_equal 401, last_response.status
      end

      should "respond not found status when incorrect id" do
        authorize "testuser", "testpass"
        get "/media/wrongid"
        assert_equal 404, last_response.status
      end

      should "respond ok status when correct credentials and id" do
        authorize "testuser", "testpass"
        get "/media/#{@media.id}"
        assert_equal 200, last_response.status
      end
    end

    context "get /media/:id.json" do
      setup do
        @media = RawQ::Media.create :media_type => "audio"
      end

      should "respond unauthorized status when missing credentials" do
        get "/media/#{@media.id}.json"
        assert_equal 401, last_response.status
      end

      should "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/#{@media.id}.json"
        assert_equal 401, last_response.status
      end

      should "respond not found status when incorrect id" do
        authorize "testuser", "testpass"
        get "/media/wrongid.json"
        assert_equal 404, last_response.status
      end

      should "respond ok status when correct credentials and id" do
        authorize "testuser", "testpass"
        get "/media/#{@media.id}.json"
        assert_equal 200, last_response.status
      end
    end

    context "get /media/:id/:source_id" do
      setup do
        @media = RawQ::Media.create :media_type => "audio"
        @source = RawQ::Source.new
        @source.file = File.join(File.dirname(__FILE__), '..', 'media', 'source.mp3')
        @media.sources << @source
      end

      should "respond unauthorized status when missing credentials" do
        get "/media/#{@media.id}/#{@source.id}"
        assert_equal 401, last_response.status
      end

      should "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/#{@media.id}/#{@source.id}"
        assert_equal 401, last_response.status
      end

      should "respond not found status when incorrect id" do
        authorize "testuser", "testpass"
        get "/media/wrongid/#{@source.id}"
        assert_equal 404, last_response.status
      end

      should "respond not found status when incorrect id" do
        authorize "testuser", "testpass"
        get "/media/#{@media.id}/wrongid"
        assert_equal 404, last_response.status
      end

      should "respond ok status when correct credentials and id" do
        authorize "testuser", "testpass"
        get "/media/#{@media.id}/#{@source.id}"
        assert_equal 200, last_response.status
      end
    end
  end
end

