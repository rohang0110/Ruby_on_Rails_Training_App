# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :table

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :reservation_date, presence: true
  validates :reservation_time, presence: true
  validates :number_of_guests, presence: true, numericality: { greater_than: 0 }
  validates :customer_name, presence: true
  validates :customer_contact, presence: true

  validate :no_double_booking
  validate :guests_not_exceed_table_capacity

  private

  def no_double_booking
    return unless table_id && reservation_date && reservation_time

    overlapping = Reservation.where(table_id: table_id,
                                    reservation_date: reservation_date,
                                    reservation_time: reservation_time)
                             .where.not(id: id)
                             .where.not(status: :cancelled)

    errors.add(:base, 'This table is already booked at the selected date and time.') if overlapping.exists?
  end

  def guests_not_exceed_table_capacity
    return unless table && number_of_guests.present?

    return unless number_of_guests > table.seats

    errors.add(:number_of_guests, "cannot exceed the table's capacity of #{table.seats}")
  end
end
