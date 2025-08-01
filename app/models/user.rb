# frozen_string_literal: true

# User model containing authentication and profile logic.
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :first_name, :last_name, :phone_number, :date_of_birth, :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :phone_number, format: { with: /\A\d{10}\z/, message: 'must be 10 digits' }

  validate :age_matches_dob

  private

  def age_matches_dob
    calculated_age = calculate_age(dob)
    age == calculated_age
  end

  def calculate_age(date)
    now = Time.zone.now
    now.year - date.year - (now.month > date.month || (now.month == date.month && now.day >= date.day) ? 0 : 1)
  end
end