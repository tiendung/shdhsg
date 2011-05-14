class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, 
  # :lockable, :timeoutable and :omniauthable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Twitter
  field :twitter_handle, :type => String
  field :twitter_oauth_token, :type => String
  field :twitter_oauth_secret, :type => String
  
  index :twitter_handle, :unique => true
  index [[:twitter_oauth_token, 1], [:twitter_oauth_secret, 1]]
  
  include Mongoid::IamAwesome
end
