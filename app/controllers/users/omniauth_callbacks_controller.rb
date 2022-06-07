class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cryptr
    handle_auth "Cryptr"
  end

  def handle_auth(kind)
    user_info = request.env['omniauth.auth']
    @user = User.from_omniauth(user_info)

    if @user.persisted?
      session[:user_id] = @user.id
      session[:access_token] = user_info['credentials']['token']

      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.auth_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "Failure. Please try again"
  end
end
