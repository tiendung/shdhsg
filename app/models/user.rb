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

  def update_info_via_twitter(force = false)
    if force || twitter_id_changed?
      t = Twitter::Client.new.user(twitter_id)
      twitter_info = t.to_hash
      self.avatar_url = t.profile_image_url
    end
  end
  
  # def twitter
  #   unless @twitter_user
  #     provider = self.authentications.find_by_provider('twitter')
  #     @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
  #   end
  #   @twitter_user
  # end
  
  include Mongoid::IamAwesome
end
