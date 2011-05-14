class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => :declare
  include Twitter::Extractor
  
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
  
  def declare
    if request.post? 
      reason = params[:reason]
      
    #Check and verify the tweet
    usernames = extract_mentioned_screen_names(params[:receiver])
    if usernames.nil? || usernames.size ==0
      flash[:error] = "Invalid input for receivers of awesomeness"
      redirect_to :root
    elsif reason.nil? || reason.empty?
      flash[:error] = "Empty reason for receivers of awesomeness is not allowed"
      redirect_to :root
    else
      receiver = usernames[0]
      p "Receiver is #{receiver}"
    
    
    #backend calculation
    
    #Post the tweet on user's twitter page
      
    
    end 
    #redirect to main page
    redirect_to :root
    elsif request.get?
      render 'declare'
    
    end
  end
  
end
