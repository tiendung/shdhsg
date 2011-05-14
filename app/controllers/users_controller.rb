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
      if current_user.credit == 0
        flash[:notice] = "You dont have any credit left, would you like to buy some?"
        redirect_to users_declare_path
      elsif usernames.nil? || usernames.size == 0
        flash[:notice] = "Invalid input for receivers of awesomeness"
        redirect_to users_declare_path
      elsif usernames.size > current_user.credit
        flash[:notice] = "You can only give maximum #{current_user.credit} awesomeness to others"
        redirect_to users_declare_path
      elsif reason.size > 134
        flash[:notice] = "Message is too long"
        redirect_to users_declare_path
      else
        #backend calculation
        usernames.each do |username|
          receiver = User.where(:twitter_id => username).first || User.new
          receiver.twitter_id = username
          receiver.save(:validate => false)
          
          result = current_user.like(receiver, reason)
          if result == true
            #Post the tweet on user's twitter page
            message = reason + " #tooa"
            begin
              current_user.twitter.update(message)
            rescue => e
              logger.info e
            end
            #redirect to main page
            redirect_to :root and return
          else
            flash[:notice] = result.to_s.humanize
            redirect_to users_declare_path and return
          end
        end
      end     
    end # end of request.post?
  end
  
end
