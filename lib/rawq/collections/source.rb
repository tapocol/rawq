module RawQ
  class Source
    include Mongoid::Document
    embedded_in :media, :class_name => "RawQ::Media"
    field :file, type: String
    field :mimetype, type: String
  end
end

