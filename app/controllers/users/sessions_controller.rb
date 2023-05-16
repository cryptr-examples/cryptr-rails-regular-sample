class Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session, only: :create

  def create
    super

    session[:user_id] = current_user&.id
  end

  def destroy
    slo_url = session.delete('omniauth.slo_url')
    session.delete(:user_id)

    if slo_url
      uri =  URI.parse(slo_url)
      target_url = request.protocol + request.host_with_port + after_sign_out_path_for(resource_name)
      new_query_ar = URI.decode_www_form(String(uri.query)) << ['target_url', target_url]
      uri.query = URI.encode_www_form(new_query_ar)
      slo_url = uri.to_s
    end

    super do
      session['omniauth.slo_url'] = slo_url if slo_url
    end
  end

  def slo_logout
    slo_url = session['omniauth.slo_url']

    if slo_url
      redirect_to slo_url, allow_other_host: true
    else
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  def after_sign_out_path_for(_)
    if session['omniauth.slo_url']
      '/users/slo/logout'
    else
      super
    end
  end
end
