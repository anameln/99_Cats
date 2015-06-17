class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    render 'new'

  end

  def create
    user = User.find_by_credentials(params[:user][:user_name],
                                    params[:user][:password])
    if user.nil?
      @user_name = params[:user][:user_name]
      render 'new'
    else
      log_in(user)
      redirect_to cats_url
    end
  end

  def destroy
    return unless logged_in?
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to cats_url
  end

end
