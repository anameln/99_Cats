class CatsController < ApplicationController

  before_action :redirect_unless_logged_in, only: [:create]
  before_action :get_current_cat, only: [:show, :edit, :update, :get_current_cat]
  before_action :redirect_unless_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    # @cat = Cat.find(params[:id])

    render :show
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner = current_user
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    # @cat = Cat.find(params[:id])
  end

  def update
    # @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private

  def get_current_cat
    @cat ||= Cat.find(params[:id])
  end

  def redirect_unless_owner
    redirect_to cats_url unless current_user?(@cat.owner)
  end

  def cat_params
    params.require(:cat).permit(:name, :color, :sex, :description, :birth_date)
  end
end
