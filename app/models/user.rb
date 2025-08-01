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
    return unless date_of_birth.present? && age.present?

    today = Date.today
    calculated_age = today.year - date_of_birth.year
    calculated_age -= 1 if date_of_birth.to_date > today.yield_self do |d|
      Date.new(d.year, date_of_birth.month, date_of_birth.day)
    end

    errors.add(:age, 'does not match your date of birth') if calculated_age != age
  end
end