require "rawq/version"
require "mongoid"
require "sinatra/rawq"

module RawQ
  autoload :Media, "rawq/media"
  autoload :Source, "rawq/source"
end

