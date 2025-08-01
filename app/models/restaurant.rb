# frozen_string_literal: true

class Restaurant < ApplicationRecord
  belongs_to :user

  include AASM

  aasm column: :status do
    state :open, initial: true
    state :closed
    state :archived

    event :close do
      transitions from: :open, to: :closed
    end

    event :archive do
      transitions from: %i[open closed], to: :archived
    end

    event :reopen do
      transitions from: %i[closed archived], to: :open
    end
  end

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :location, presence: true, length: { minimum: 3, maximum: 200 }
  validates :cuisine_type, presence: true, length: { minimum: 3, maximum: 100 }

  validates :rating,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 },
            allow_nil: true

  validates :likes,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :note, length: { maximum: 1000 }, allow_blank: true

  validates :status, inclusion: { in: %w[open closed archived] }
end
