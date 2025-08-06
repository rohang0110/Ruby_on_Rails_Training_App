class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_staff!, only: [:index]

  # Staff: View all feedbacks
  def index
    @feedbacks = Feedback.order(created_at: :desc).map do |feedback|
      {
        id: feedback.id,
        rating: feedback.rating,
        comment: feedback.comment,
        customer_name: User.find_by(id: feedback.user_id)&.first_name || 'Unknown',
        restaurant_name: fetch_restaurant_name(feedback.restaurant_id),
        created_at: feedback.created_at
      }
    end
  end

  # Customer: Show feedback form
  def new
    @feedback = Feedback.new(
      current_url: params[:current_url],
      restaurant_id: params[:restaurant_id],
      user: current_user
    )
  end

  # Customer: Submit feedback
  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    @feedback.current_url ||= request.referer

    if @feedback.save
      redirect_to @feedback.current_url || root_path, notice: 'Thank you for your feedback!'
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:rating, :comment, :current_url, :restaurant_id)
  end

  def authorize_staff!
    redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_user.staff?
  end

  def fetch_restaurant_name(restaurant_id)
    return 'App Feedback' if restaurant_id.blank?

    Restaurant.find_by(id: restaurant_id)&.name || 'Unknown Restaurant'
  end
end
