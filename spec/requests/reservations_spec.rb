require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  include ActiveJob::TestHelper

  let(:restaurant) { create(:restaurant) }
  let(:user) { create(:user) }
  let(:reservation) { create(:reservation, restaurant: restaurant, user: user, status: :pending) }

  before { sign_in user }

  describe 'PATCH /restaurants/:restaurant_id/reservations/:id/confirm' do
    it 'confirms the reservation and sends an email' do
      perform_enqueued_jobs do
        patch confirm_restaurant_reservation_path(restaurant_id: restaurant.id, id: reservation.id)

        expect(response).to redirect_to(restaurant_reservations_path(restaurant))
        expect(flash[:notice]).to eq('Reservation confirmed and email sent.')
        expect(reservation.reload.status).to eq('confirmed')
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include('Reservation Confirmed')
    end
  end

  describe 'PATCH /restaurants/:restaurant_id/reservations/:id/cancel' do
    it 'cancels the reservation and sends an email' do
      perform_enqueued_jobs do
        patch cancel_restaurant_reservation_path(restaurant_id: restaurant.id, id: reservation.id)

        expect(response).to redirect_to(restaurant_reservations_path(restaurant))
        expect(flash[:alert]).to eq('Reservation cancelled and email sent.')
        expect(reservation.reload.status).to eq('cancelled')
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include('Reservation Cancelled')
    end
  end
end
