require 'byebug'
class CatRentalRequestsController < ApplicationController

  before_action :redirect_unless_cat_owner, only: [:approve, :deny]

  def new
    @request = CatRentalRequest.new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @request.requester = current_user
    if @request.save
      redirect_to cat_url(params[:cat_rental_request][:cat_id])
    else
      render :new
    end
  end

  def approve
    current_request.approve!
    redirect_to cat_url(current_request.cat)
  end

  def deny
    current_request.deny!
    redirect_to cat_url(current_request.cat)
  end

  private

  def current_request
    CatRentalRequest.find(params[:id])
  end

  def redirect_unless_cat_owner
    redirect_to cat_url(current_request.cat) unless current_user?(current_request.cat.owner)
  end

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
