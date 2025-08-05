class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :reservations
  enum :status, { available: 0, reserved: 1, occupied: 2 }
end
