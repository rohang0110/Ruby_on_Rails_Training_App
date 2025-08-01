class RestaurantsController < ApplicationController
  before_action :authenticate_user!

  def new
    @restaurant = current_user.restaurants.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to root_path, notice: 'Your Restaurant was created and is open for business.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @restaurants = Restaurant.where(status: :open).order(created_at: :desc)
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :cuisine_type)
  end
end
