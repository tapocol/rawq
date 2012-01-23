module Sinatra
  module RawQExt
    module Helpers
    end

    def self.registered(app)
      app.use Rack::Auth::Basic, "Restricted Area" do |username, password|
        [username, password] == [app.username, app.password]
      end

      app.get "/" do
        send_file File.join(app.public_folder, "index.html")
      end

      app.get "/media" do
        media = RawQ::Media.all
        media.to_json :include => :sources
      end

      app.get "/media/:id" do
        begin
          media = RawQ::Media.find(params[:id])
        rescue Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId
          raise Sinatra::NotFound
        end
        media.to_json :include => :sources
      end

      app.get "/media/:id/:source_id" do
        begin
          media = RawQ::Media.find(params[:id])
          source = media.sources.find(params[:source_id])
        rescue Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId
          raise Sinatra::NotFound
        end
        send_file File.join(source.file), :type => source.mimetype
      end
    end
  end
end

