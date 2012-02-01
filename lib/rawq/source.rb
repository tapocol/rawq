module RawQ
  class Source
    include Mongoid::Document
    store_in :sources
    embedded_in :media, :class_name => "RawQ::Media"
    field :file, type: String
    field :filename, type: String
    field :mimetype, type: String
  end
end

