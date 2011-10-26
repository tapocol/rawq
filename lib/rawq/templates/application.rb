require "sinatra"
require "mongoid"
require File.join(File.dirname(__FILE__), "/lib/config")

class Media
  include Mongoid::Document
  embeds_many :sources
end

class Source
  include Mongoid::Document
  embedded_in :media
  field :file, type: String
  field :mimetype, type: String
end

module Sinatra
  module RawQExtension
    def self.registered(app)
      app.use Rack::Auth::Basic, "Restricted Area" do |username, password|
        [username, password] == [app.username, app.password]
      end

      app.get "/" do
        send_file File.join(settings.public_folder, "index.html")
      end

      app.get "/media" do
        media = Media.all
        media.to_json :include => :sources
      end

      app.get "/media/:id" do
        begin
          media = Media.find(params[:id])
        rescue Mongoid::Errors::DocumentNotFound
          raise Sinatra::NotFound
        end
        media.to_json :include => :sources
      end

      app.get "/media/:id/:source_id" do
        begin
          media = Media.find(params[:id])
          source = media.sources.find(params[:source_id])
        rescue Mongoid::Errors::DocumentNotFound
          raise Sinatra::NotFound
        end
        send_file File.join(source.file), :type => source.mimetype
      end
    end
  end

  register RawQExtension
end

