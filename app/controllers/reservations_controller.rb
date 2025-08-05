class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[confirm cancel]
  before_action :set_restaurant, only: [:index]

  def index
    @reservations = @restaurant.reservations.includes(:user, :table).order(
      reservation_date: :asc, reservation_time: :asc
    )
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @reservation = @restaurant.reservations.new
    @reservation.customer_name = "#{current_user.first_name} #{current_user.last_name}"
    @reservation.customer_contact = current_user.phone_number
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @reservation = @restaurant.reservations.new(reservation_params)
    @reservation.user = current_user
    @reservation.status = :pending

    if @reservation.save
      redirect_to root_path, notice: 'Reservation submitted and is pending confirmation.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    if @reservation.update(status: :confirmed)
      ReservationMailer.reservation_status_email(@reservation).deliver_later
      redirect_to restaurant_reservations_path(@reservation.restaurant), notice: 'Reservation confirmed and email sent.'
    else
      redirect_to restaurant_reservations_path(@reservation.restaurant), alert: 'Failed to confirm reservation.'
    end
  end

  def cancel
    if @reservation.update(status: :cancelled)
      ReservationMailer.reservation_status_email(@reservation).deliver_later
      redirect_to restaurant_reservations_path(@reservation.restaurant), alert: 'Reservation cancelled and email sent.'
    else
      redirect_to restaurant_reservations_path(@reservation.restaurant), alert: 'Failed to cancel reservation.'
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(
      :reservation_date, :reservation_time, :number_of_guests, :table_id,
      :customer_name, :customer_contact
    )
  end
end
