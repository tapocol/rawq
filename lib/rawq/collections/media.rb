module RawQ
  class Media
    include Mongoid::Document
    store_in :media
    embeds_many :sources, :class_name => "RawQ::Source"
    field :media_type, :type => String

    validates_inclusion_of :media_type, :in => ["audio", "video"]
  end
end

