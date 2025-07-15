# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sign Up', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:valid_attributes) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'Secure123!',
      password_confirmation: 'Secure123!',
      phone_number: '9876543210',
      age: 25,
      dob_day: '10',
      dob_month: '7', # Use numeric month (July = 7)
      dob_year: (Date.today.year - 25).to_s
    }
  end

  it 'allows valid sign up' do
    visit new_user_registration_path

    fill_in 'First name', with: valid_attributes[:first_name]
    fill_in 'Last name', with: valid_attributes[:last_name]
    fill_in 'Email', with: valid_attributes[:email]
    fill_in 'Password', with: valid_attributes[:password]
    fill_in 'Password confirmation', with: valid_attributes[:password_confirmation]
    fill_in 'Phone number', with: valid_attributes[:phone_number]
    fill_in 'Age', with: valid_attributes[:age]

    select valid_attributes[:dob_day], from: 'user[date_of_birth(3i)]'
    select valid_attributes[:dob_month], from: 'user[date_of_birth(2i)]'
    select valid_attributes[:dob_year], from: 'user[date_of_birth(1i)]'

    click_button 'Sign up'

    expect(page).to have_content('Welcome to Rails App!')
    expect(page).to have_content("You are signed in as #{valid_attributes[:first_name]}!")
  end

  it 'fails if password confirmation does not match' do
    visit new_user_registration_path

    fill_in 'First name', with: valid_attributes[:first_name]
    fill_in 'Last name', with: valid_attributes[:last_name]
    fill_in 'Email', with: 'mismatch@example.com'
    fill_in 'Password', with: 'Secure123!'
    fill_in 'Password confirmation', with: 'Mismatch123!'
    fill_in 'Phone number', with: valid_attributes[:phone_number]
    fill_in 'Age', with: valid_attributes[:age]

    select valid_attributes[:dob_day], from: 'user[date_of_birth(3i)]'
    select valid_attributes[:dob_month], from: 'user[date_of_birth(2i)]'
    select valid_attributes[:dob_year], from: 'user[date_of_birth(1i)]'

    click_button 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it 'fails with blank fields' do
    visit new_user_registration_path
    click_button 'Sign up'
    expect(page).to have_content("can't be blank")
  end

  it 'fails with invalid email format' do
    visit new_user_registration_path

    fill_in 'First name', with: valid_attributes[:first_name]
    fill_in 'Last name', with: valid_attributes[:last_name]
    fill_in 'Email', with: 'invalid_email'
    fill_in 'Password', with: valid_attributes[:password]
    fill_in 'Password confirmation', with: valid_attributes[:password_confirmation]
    fill_in 'Phone number', with: valid_attributes[:phone_number]
    fill_in 'Age', with: valid_attributes[:age]

    select valid_attributes[:dob_day], from: 'user[date_of_birth(3i)]'
    select valid_attributes[:dob_month], from: 'user[date_of_birth(2i)]'
    select valid_attributes[:dob_year], from: 'user[date_of_birth(1i)]'

    click_button 'Sign up'

    expect(page).to have_content('Email is invalid')
  end

  it 'fails if phone number is not 10 digits' do
    visit new_user_registration_path

    fill_in 'First name', with: valid_attributes[:first_name]
    fill_in 'Last name', with: valid_attributes[:last_name]
    fill_in 'Email', with: 'shortphone@example.com'
    fill_in 'Password', with: valid_attributes[:password]
    fill_in 'Password confirmation', with: valid_attributes[:password_confirmation]
    fill_in 'Phone number', with: '12345'
    fill_in 'Age', with: valid_attributes[:age]

    select valid_attributes[:dob_day], from: 'user[date_of_birth(3i)]'
    select valid_attributes[:dob_month], from: 'user[date_of_birth(2i)]'
    select valid_attributes[:dob_year], from: 'user[date_of_birth(1i)]'

    click_button 'Sign up'

    expect(page).to have_content('Phone number must be 10 digits')
  end

  it 'fails if age doesn’t match date of birth' do
    visit new_user_registration_path

    fill_in 'First name', with: 'AgeMismatch'
    fill_in 'Last name', with: 'User'
    fill_in 'Email', with: 'agemismatch@example.com'
    fill_in 'Password', with: valid_attributes[:password]
    fill_in 'Password confirmation', with: valid_attributes[:password_confirmation]
    fill_in 'Phone number', with: valid_attributes[:phone_number]
    fill_in 'Age', with: 10 # deliberately wrong

    select valid_attributes[:dob_day], from: 'user[date_of_birth(3i)]'
    select valid_attributes[:dob_month], from: 'user[date_of_birth(2i)]'
    select valid_attributes[:dob_year], from: 'user[date_of_birth(1i)]'

    click_button 'Sign up'

    expect(page).to have_content('Age does not match your date of birth')
  end
end
