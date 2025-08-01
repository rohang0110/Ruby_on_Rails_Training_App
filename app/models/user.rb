# frozen_string_literal: true

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

    calculated_age = ((Time.zone.today - date_of_birth).to_i / 365.25).floor
    return unless calculated_age != age

    errors.add(:age, 'does not match your date of birth')
  end
end
