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
  field :twitter_id
  validates_presence_of :twitter_id

  include Mongoid::IamAwesome
end
