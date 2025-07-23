# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /edit' do
    it 'renders the edit form successfully' do
      get edit_profile_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Update Personal Data')
    end
  end

  describe 'PATCH /profile' do
    let(:valid_date_of_birth) { 30.years.ago.to_date }

    let(:valid_attributes) do
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.unique.email,
        phone_number: Faker::Number.number(digits: 10),
        age: 30,
        date_of_birth: valid_date_of_birth
      }
    end

    subject do
      patch profile_path, params: { user: update_params }
    end

    shared_examples 'does not update and renders errors' do |error_message|
      it 'does not update the user and renders errors' do
        original_name = user.first_name
        subject
        expect(response.body).to include('error').or include(error_message)
        expect(user.reload.first_name).to eq(original_name)
      end
    end

    context 'with valid attributes' do
      let(:update_params) { valid_attributes }

      it 'updates the user and redirects to edit path' do
        subject
        expect(response).to redirect_to(edit_profile_path)
        follow_redirect!
        expect(response.body).to include('Update Personal Data')
        expect(user.reload.first_name).to eq(update_params[:first_name])
      end
    end

    context 'with missing first name' do
      let(:update_params) { valid_attributes.merge(first_name: '') }
      include_examples 'does not update and renders errors', "First name can't be blank"
    end

    context 'with invalid email format' do
      let(:update_params) { valid_attributes.merge(email: 'bad-email') }
      include_examples 'does not update and renders errors', 'Email is invalid'
    end

    context 'with invalid phone number' do
      let(:update_params) { valid_attributes.merge(phone_number: '123abc') }
      include_examples 'does not update and renders errors', 'Phone number must be 10 digits'
    end

    context 'with negative age' do
      let(:update_params) { valid_attributes.merge(age: -3) }
      include_examples 'does not update and renders errors', 'Age must be greater than or equal to 0'
    end

    context "when age doesn't match DOB" do
      let(:update_params) { valid_attributes.merge(age: 10) }
      include_examples 'does not update and renders errors', 'Age does not match your date of birth'
    end
  end
end
