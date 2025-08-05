require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:restaurant) }
    it { should belong_to(:table) }
  end

  describe 'validations' do
    it { should validate_presence_of(:reservation_date) }
    it { should validate_presence_of(:reservation_time) }
    it { should validate_presence_of(:number_of_guests) }
    it { should validate_presence_of(:customer_name) }
    it { should validate_presence_of(:customer_contact) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:status).with_values(
        pending: 0, confirmed: 1, cancelled: 2
      )
    end
  end
end
