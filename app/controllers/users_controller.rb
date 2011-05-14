class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => :declare
  include Twitter::Extractor
  
  def twitter
    auth_hash = request.env['omniauth.auth']
    twitter_id = auth_hash['user_info']['nickname']
    user = User.where(:twitter_id => twitter_id).first || User.new
    user.twitter_id = twitter_id
    user.user_info = auth_hash['user_info']
    user.credentials = auth_hash['credentials']
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
      usernames = extract_mentioned_screen_names(reason).uniq
      if usernames.nil? || usernames.size == 0
        flash[:error] = "Invalid input for receivers of awesomeness"
        render 'declare'
      elsif usernames.size > current_user.credit
        flash[:error] = "You can only give maximum #{current_user.credit} awesomeness to others"
        render 'declare'
      elsif reason.size > 134
        flash[:error] = "Message is too long"
        render 'declare'
      else
        #backend calculation
        usernames.each do |username|
          receiver = User.where(:twitter_id => username).first
          result = current_user.like(receiver, reason)
          if result == true
            #Post the tweet on user's twitter page
            message = reason + " #tooa"
            current_user.twitter.update(message)
            #redirect to main page
            redirect_to :root
          else
            flash[:error] = result.to_s.humanize
            render 'declare'
          end
        end
      end 
    elsif request.get?
      render 'declare'    
    end
  end
  
end
