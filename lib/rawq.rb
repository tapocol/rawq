require "rawq/version"
require "mongoid"
require "sinatra/rawq"

module RawQ
  autoload :Media, "rawq/collections/media"
  autoload :Source, "rawq/collections/source"
end

