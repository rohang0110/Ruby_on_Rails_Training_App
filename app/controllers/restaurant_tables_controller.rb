class RestaurantTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_table, only: %i[edit update destroy]

  def index
    @filter = params[:status].presence || 'all'
    @sort_column = params[:sort] || 'id'
    @direction = params[:direction] == 'desc' ? 'desc' : 'asc'

    @tables = @restaurant.tables
                         .yield_self { |rel| filter_tables(rel) }
                         .order("#{@sort_column} #{@direction}")
                         .paginate(page: params[:page], per_page: 5)
  end

  def new
    @table = @restaurant.tables.new
  end

  def create
    @table = @restaurant.tables.new(table_params)
    if @table.save
      redirect_to restaurant_tables_path(@restaurant), notice: 'Table created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @table.update(table_params)
      redirect_to restaurant_tables_path(@restaurant), notice: 'Table updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @table.destroy
    redirect_to restaurant_tables_path(@restaurant), notice: 'Table deleted.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def set_table
    @table = @restaurant.tables.find(params[:id])
  end

  def table_params
    params.require(:table).permit(:table_number, :seats, :status)
  end

  def filter_tables(scope)
    if Table.statuses.key?(@filter)
      scope.where(status: Table.statuses[@filter])
    else
      scope
    end
  end
end
