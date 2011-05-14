module Mongoid
  module Likeable
    extend ActiveSupport::Concern

    included do    
      field :likes, :type => Array, :default => []
      field :point
      field :credit
    end
    
    module ClassMethods
    end
    
    def liked?(other)
    end
    
    def like(other)
      return false if self == other
      # Need to load self and other object in order to do more things 
      # rather than updating likes data
    end
  end
end