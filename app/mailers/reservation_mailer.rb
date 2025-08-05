class ReservationMailer < ApplicationMailer
  default from: 'notifications@yMyapp.com'

  def reservation_status_email(reservation)
    @reservation = reservation
    mail(
      to: reservation.customer_contact,
      subject: "Your Reservation is #{reservation.status.capitalize}"
    )
  end
end
