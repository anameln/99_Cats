class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    if @request.save
      redirect_to cat_url(params[:cat_rental_request][:cat_id])
    else
      render :new
    end
  end

  def approve
    CatRentalRequest.find(params[:id]).approve!
    redirect_to cat_url(params[:cat_id])
  end

  def deny
    CatRentalRequest.find(params[:id]).deny!
    redirect_to cat_url(params[:cat_id])
  end

  private

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
