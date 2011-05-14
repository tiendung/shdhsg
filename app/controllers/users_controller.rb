class UsersController < ApplicationController
  def twitter
    auth_hash = request.env['omniauth.auth']
    twitter_id = auth_hash['user_info']['nickname']
    user = User.where(:twitter_id => twitter_id).first || User.new
    user.twitter_id = twitter_id
    user.user_info = auth_hash['user_info']
    user.save!
    sign_in(User, user)
    redirect_to :root
  end
  
  def failure
    logger.info flash[:error] = "Fail to log in"
    redirect_to :root
  end
end
