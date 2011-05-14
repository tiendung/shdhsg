class PagesController < ApplicationController
  def home
    u = User.desc(:awesome).limit(55)
    @users = []
    offset = 0
    1.upto(Settings.pyramid_height).each do |i|
      line_users = u[offset, i]
      @users << line_users
      offset += i
    end
  end
end
