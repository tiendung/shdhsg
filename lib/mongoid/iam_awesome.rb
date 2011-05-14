class Awesomeness
  include Mongoid::Document
  embedded_in :awesomeness, :polymorphic => true
  field :giver_id
  field :reason
end
  
module Mongoid
  module IamAwesome
    extend ActiveSupport::Concern

    included do
      embeds_many :awesomenesses
      field :point, :default => 0
      field :credit, :default => Settings.default_credit
    end
    
    module ClassMethods
    end
    
    def normalize_reason(reason)
      return false if reason.blank?
      reason.downcase!
      reason.strip!
      reason.gsub!(/\s+/, ' ')
      return true
    end
    
    def liked?(other, reason = nil)
      normalize_reason(reason)
      !liked(other, reason).blank?
    end
    
    # Return Awesomeness or nil
    def liked(other, reason = nil)
      normalize_reason(reason)
      awesomenesses = []
      other.awesomenesses.each do |awesomeness|
        if awesomeness.giver_id == self.id 
          if reason.present? && awesomeness.reason == reason
            puts awesomeness.inspect, reason
            return awesomeness
          end
          awesomenesses << awesomeness
        end
      end
      reason.blank? ? awesomenesses : nil
    end
    
    # You like somebody, you give him an awesomeness with a specific reason
    def like(other, reason)
      normalize_reason(reason)
      
      if self == other || liked?(other, reason)
        return false
      end
      
      other.awesomenesses << Awesomeness.new(
        :giver_id => self.id,
        :reason => reason
      )
      other.point += 1
      other.save
      
      other
    end
  end
end
