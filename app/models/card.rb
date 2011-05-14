class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  
  field :image_uid
  image_accessor :image
  validates_presence_of :image
end
