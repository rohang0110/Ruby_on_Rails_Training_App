# app/models/feedback.rb
class Feedback < ApplicationRecord
  belongs_to :user
  def restaurant
    Restaurant.find_by(id: restaurant_id)
  end

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
  validates :restaurant_id, numericality: { only_integer: true }, allow_nil: true
end
