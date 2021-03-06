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
      field :awesome, :type => Integer, :default => 0
      field :credit, :type => Integer, :default => Settings.default_credit
      index [[:awesome, -1]]
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
      return nil if other.awesomenesses.blank?
      normalize_reason(reason)
      awesomenesses = []
      other.awesomenesses.each do |awesomeness|
        if awesomeness.giver_id == self.id 
          if reason.present? && awesomeness.reason == reason
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
      
      return :cannot_like_self if self == other
      return :cannot_like_for_the_same_reason if liked?(other, reason)
      
      if not admin?
        return :no_credits_left if self.credit == 0
        return :reach_limit if liked(other).try(:size).to_i >= Settings.likes_limit
        self.credit -= 1
        self.save
      end
      
      other.credit += 1
      other.awesome += 1
      other.awesomenesses << Awesomeness.new(
        :giver_id => self.id,
        :reason => reason
      )
      other.save
      true
    end
  end
end
