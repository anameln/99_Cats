class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_in(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def redirect_if_logged_in
    redirect_to cats_url if logged_in?
  end

  def auth_token_input
    <<-HTML.html_safe
      <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}">
    HTML
  end


  helper_method :current_user, :logged_in?, :log_in, :auth_token_input

end
