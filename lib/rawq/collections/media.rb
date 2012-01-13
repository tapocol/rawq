module RawQ
  class Media
    include Mongoid::Document
    embeds_many :sources, :class_name => "RawQ::Source"
  end
end

