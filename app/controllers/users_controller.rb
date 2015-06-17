class UsersController < ApplicationController
  before_action :redirect_if_logged_in

  def new
    render 'new'
  end

  def create
    user = User.new(user_params)
    if user.save
      log_in(user)
      redirect_to user_url(user)
    else
      @user_name = user.user_name
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end


end
