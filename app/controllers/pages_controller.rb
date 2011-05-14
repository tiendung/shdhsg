class PagesController < ApplicationController
  def home
    @users = User.all.limit(5)
  end
end
