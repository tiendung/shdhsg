class User
  # IMPORTANT: If you want to support sign in via twitter you MUST remove the
  #            :validatable module, otherwise the user will never be saved
  #            since it's email and password is blank.
  #            :validatable checks only email and password so it's safe to remove

  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, 
  # :lockable, :timeoutable and :omniauthable, :trackable
  devise :database_authenticatable, :rememberable, :omniauthable, :trackable
  
  field :user_info, :type => Hash
  field :twitter_info, :type => Hash
  field :twitter_id
  field :avatar_url
  validates_presence_of :twitter_id
  
  before_save :update_info_via_twitter

  def self.create_lord!
    lord = User.new
    lord.twitter_id = 'shdhsg'
    lord.credit = 999_999_999
    lord.save(:validate => false)
    lord
  end
  
  def self.lord
    @@lord = User.where(:twitter_id => 'shdhsg').first || create_lord!
  end
  
  def lord?
    self == User.lord
  end
  
  after_create do
    User.lord.like(self, 'you attend SuperHappyDevHouseSG')
  end

  def update_info_via_twitter(force = false)
    if force || twitter_id_changed?
      t = Twitter::Client.new.user(twitter_id)
      self.twitter_info = t.to_hash
      self.avatar_url = t.profile_image_url
    end
  end
  
  include Mongoid::IamAwesome
end
