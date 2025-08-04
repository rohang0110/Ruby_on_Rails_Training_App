class MenuItemsController < ApplicationController
  before_action :set_restaurant
  before_action :set_menu_item, only: %i[edit update destroy]

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_items = @restaurant.menu_items.order(created_at: :desc)

    # Apply filters
    @menu_items = @menu_items.where(category: params[:category]) if params[:category].present?

    if params[:available].present?
      available_value = ActiveModel::Type::Boolean.new.cast(params[:available])
      @menu_items = @menu_items.where(available: available_value)
    end

    @menu_items = @restaurant.menu_items.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def create
    @menu_item = @restaurant.menu_items.new(menu_item_params)
    if @menu_item.save
      redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item created successfully.'
    else
      @menu_items = @restaurant.menu_items.order(:item_name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item deleted.'
  end

  def new
    @menu_item = @restaurant.menu_items.new
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = @restaurant.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:item_name, :description, :price, :category, :available)
  end
end
