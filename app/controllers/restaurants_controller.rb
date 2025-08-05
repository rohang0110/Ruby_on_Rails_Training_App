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
    sortable_columns = %w[id name rating status]
    @sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : 'id'

    @sort_direction = if @sort_column == 'rating'
                        'desc'
                      else
                        'asc'
                      end

    @restaurants =
      if current_user.staff?
        current_user.restaurants.order("#{@sort_column} #{@sort_direction}")
      elsif current_user.customer?
        Restaurant.where(status: :open).order("#{@sort_column} #{@sort_direction}")
      else
        Restaurant.none
      end

    @restaurants = @restaurants.paginate(page: params[:page], per_page: 9)
  end
end
