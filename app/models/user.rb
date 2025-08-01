# frozen_string_literal: true

# User model containing authentication and profile logic.
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :restaurants, dependent: :destroy

  # Validations
  validates :first_name, :last_name, :phone_number, :date_of_birth, :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :phone_number, format: { with: /\A\d{10}\z/, message: 'must be 10 digits' }

  validate :age_matches_dob
  has_one_attached :avatar

  validate :avatar_format
  validate :avatar_size
  validate :avatar_dimensions

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

  def avatar_format
    return unless avatar.attached?

    return if avatar.content_type.in?(%w[image/jpeg image/png])

    errors.add(:avatar, 'must be JPEG or PNG')
  end

  def avatar_size
    return unless avatar.attached?

    return unless avatar.byte_size > 10.megabytes

    errors.add(:avatar, 'size must be less than 10MB')
  end

  def avatar_dimensions
    return unless avatar.attached?

    begin
      avatar.analyze unless avatar.analyzed?
      metadata = avatar.blob.metadata
      [metadata[:width], metadata[:height]]
    rescue ActiveStorage::FileNotFoundError
      Rails.logger.warn("Missing avatar file for user #{id}")
      nil
    end
  end
end

