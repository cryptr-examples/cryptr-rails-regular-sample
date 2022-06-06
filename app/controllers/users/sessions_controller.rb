class Users::SessionsController < Devise::SessionsController
  def create
    super

    session[:user_id] = current_user&.id
  end
end
