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

class SinatraRawQExtTest < MiniTest::Spec
  include Rack::Test::Methods

  def app
    TestApp
  end

  describe "registered" do
    describe "get /" do
      it "respond unauthorized status when missing credentials" do
        get "/"
        assert_equal 401, last_response.status
      end

      it "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/"
        assert_equal 401, last_response.status
      end

      it "respond ok status when correct credentials" do
        authorize "testuser", "testpass"
        get "/"
        assert_equal 200, last_response.status
      end
    end

    describe "get /media" do
      it "respond unauthorized status when missing credentials" do
        get "/media"
        assert_equal 401, last_response.status
      end

      it "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media"
        assert_equal 401, last_response.status
      end

      it "respond ok status when correct credentials" do
        authorize "testuser", "testpass"
        get "/media"
        assert_equal 200, last_response.status
      end
    end

    describe "get /media/:id" do
      it "respond unauthorized status when missing credentials" do
        get "/media/1234"
        assert_equal 401, last_response.status
      end

      it "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/1234"
        assert_equal 401, last_response.status
      end

      it "respond not found status when missing id" do
        authorize "testuser", "testpass"
        get "/media/wrongid"
        assert_equal 404, last_response.status
      end

      it "respond not found status when invalid id" do
        authorize "testuser", "testpass"
        get "/media/zxcv"
        assert_equal 404, last_response.status
      end

      it "respond ok status when correct credentials and id" do
        authorize "testuser", "testpass"
        get "/media/1234"
        assert_equal 200, last_response.status
      end
    end

    describe "get /media/:id.json" do
      it "respond unauthorized status when missing credentials" do
        get "/media/1234.json"
        assert_equal 401, last_response.status
      end

      it "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/1234.json"
        assert_equal 401, last_response.status
      end

      it "respond not found status when missing id" do
        authorize "testuser", "testpass"
        get "/media/wrongid.json"
        assert_equal 404, last_response.status
      end

      it "respond not found status when invalid id" do
        authorize "testuser", "testpass"
        get "/media/zxcv.json"
        assert_equal 404, last_response.status
      end

      it "respond ok status when correct credentials and id" do
        authorize "testuser", "testpass"
        get "/media/1234.json"
        assert_equal 200, last_response.status
      end
    end

    describe "get /media/:id/:source_id" do
      it "respond unauthorized status when missing credentials" do
        get "/media/1234/5678"
        assert_equal 401, last_response.status
      end

      it "respond unauthorized status when incorrect credentials" do
        authorize "wronguser", "wrongpass"
        get "/media/1234/5678"
        assert_equal 401, last_response.status
      end

      it "respond not found status when missing media id" do
        authorize "testuser", "testpass"
        get "/media/wrongid/5678"
        assert_equal 404, last_response.status
      end

      it "respond not found status when missing source id" do
        authorize "testuser", "testpass"
        get "/media/1234/wrongid"
        assert_equal 404, last_response.status
      end

      it "respond not found status when invalid media id" do
        authorize "testuser", "testpass"
        get "/media/zxcv/5678"
        assert_equal 404, last_response.status
      end

      it "respond not found status when invalid source id" do
        authorize "testuser", "testpass"
        get "/media/1234/zxcv"
        assert_equal 404, last_response.status
      end

      it "respond ok status when correct credentials and ids" do
        authorize "testuser", "testpass"
        get "/media/1234/5678"
        assert_equal 200, last_response.status
      end
    end
  end
end

