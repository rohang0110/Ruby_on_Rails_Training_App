require 'rails_helper'

RSpec.describe ReservationMailer, type: :mailer do
  describe '#reservation_status_email' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:restaurant) { create(:restaurant) }
    let(:table) { create(:table, restaurant: restaurant) }
    let(:reservation) do
      create(:reservation,
             user: user,
             restaurant: restaurant,
             table: table, # Add this line
             customer_name: 'John Doe',
             customer_contact: '9999999999',
             status: :confirmed)
    end

    let(:mail) { ReservationMailer.with(reservation: reservation).reservation_status_email }

    it 'renders the subject' do
      expect(mail.subject).to eq('Your reservation status has been updated')
    end

    it "sends to the reservation's user email" do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['no-reply@example.com']) # adjust if you have a different sender
    end

    it 'includes the reservation details in the body' do
      expect(mail.body.encoded).to include('John Doe')
      expect(mail.body.encoded).to include('confirmed')
    end
  end
end
