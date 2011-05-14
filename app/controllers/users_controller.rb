class UsersController < ApplicationController
  def twitter
    #TODO: create user and login
  end
  
  def failure
    #TODO: log report failure
    redirect_to :root
  end
end