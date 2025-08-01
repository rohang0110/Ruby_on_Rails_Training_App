# frozen_string_literal: true

# ApplicationHelper contains helper methods that are available across all views in the application
module ApplicationHelper
  def toggle_direction(column)
    if params[:sort] == column
      params[:direction] == 'asc' ? 'desc' : 'asc'
    else
      'asc'
    end
  end
end
