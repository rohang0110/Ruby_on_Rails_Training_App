class RestaurantTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant

  def index
    @filter = params[:status].presence || 'all'
    @sort_column = params[:sort] || 'id'
    @direction = params[:direction] == 'desc' ? 'desc' : 'asc'

    @tables = @restaurant.tables
                         .yield_self { |rel| filter_tables(rel) }
                         .order("#{@sort_column} #{@direction}")
                         .paginate(page: params[:page], per_page: 5)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def filter_tables(scope)
    if Table.statuses.key?(@filter)
      scope.where(status: Table.statuses[@filter])
    else
      scope
    end
  end
end
