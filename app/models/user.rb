class User
  # To use devise-twitter don't forget to include the :twitter_oauth module:
  # e.g. devise :database_authenticatable, ... , :twitter_oauth

  # IMPORTANT: If you want to support sign in via twitter you MUST remove the
  #            :validatable module, otherwise the user will never be saved
  #            since it's email and password is blank.
  #            :validatable checks only email and password so it's safe to remove

  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, 
  # :lockable, :timeoutable and :omniauthable, :trackable
  devise :database_authenticatable, :rememberable, :omniauthable, :trackable
  
  attr_accessible :email
  # Twitter
  field :twitter_handle, :type => String
  field :twitter_oauth_token, :type => String
  field :twitter_oauth_secret, :type => String
  field :twitter_id
  
  index :twitter_handle, :unique => true
  index [[:twitter_oauth_token, 1], [:twitter_oauth_secret, 1]]
  
  include Mongoid::IamAwesome
end
