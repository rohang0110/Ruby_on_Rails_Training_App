# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'POST /api/v1/users', type: :request do
  let(:valid_params) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      phone_number: '9876543210',
      age: 23,
      date_of_birth: 23.years.ago.to_date.to_s,
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  describe 'Unauthorized access' do
    it_behaves_like 'unauthorized access', :post, '/api/v1/users', valid_params
  end

  describe 'POST /api/v1/users' do
    context 'with valid parameters' do
      it 'creates a user and returns 201' do
        token = create(:token) # Make sure you have a valid token factory
        post '/api/v1/users', params: valid_params, headers: { 'Authorization' => token.value }, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json).to include(
          'id',
          'first_name' => valid_params[:first_name],
          'last_name' => valid_params[:last_name],
          'email' => valid_params[:email]
        )
        expect(json).to have_key('created_at')
        expect(json).not_to include('password', 'encrypted_password')
      end
    end

    context 'with age not matching date_of_birth' do
      it 'returns 422' do
        token = create(:token)
        post '/api/v1/users', params: valid_params.merge(age: 25), headers: { 'Authorization' => token.value },
                              as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('age')
      end
    end

    context 'with invalid email format' do
      it 'returns 422' do
        token = create(:token)
        post '/api/v1/users', params: valid_params.merge(email: 'invalidemail'),
                              headers: { 'Authorization' => token.value }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('email')
      end
    end

    context 'with invalid phone number' do
      it 'returns 422' do
        token = create(:token)
        post '/api/v1/users', params: valid_params.merge(phone_number: '123'),
                              headers: { 'Authorization' => token.value }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('phone_number')
      end
    end

    context 'with mismatched password_confirmation' do
      it 'returns 422' do
        token = create(:token)
        post '/api/v1/users', params: valid_params.merge(password_confirmation: 'wrongpass'),
                              headers: { 'Authorization' => token.value }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('password_confirmation')
      end
    end

    context 'with duplicate email' do
      before do
        create(:user, email: valid_params[:email])
      end

      it 'returns 422' do
        token = create(:token)
        post '/api/v1/users', params: valid_params, headers: { 'Authorization' => token.value }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('email')
      end
    end
  end
end
