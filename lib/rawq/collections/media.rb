module RawQ
  class Media
    include Mongoid::Document
    store_in :media
    embeds_many :sources, :class_name => "RawQ::Source"
  end
end

