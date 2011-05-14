class PagesController < ApplicationController
  def home
    @users = User.desc(:awesome)
  end
end
