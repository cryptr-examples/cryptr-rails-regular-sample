class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find session[:user_id] unless session[:user_id].nil?
  end
end
