# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login Access Control', type: :system do
  let!(:staff_user) do
    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      password: 'password123',
      password_confirmation: 'password123',
      phone_number: Faker::Number.number(digits: 10),
      age: 23,
      date_of_birth: '2002-01-10',
      role_type: :staff,
      status: :active
    )
  end

  let!(:customer_user) do
    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      password: 'password123',
      password_confirmation: 'password123',
      phone_number: Faker::Number.number(digits: 10),
      age: 23,
      date_of_birth: '2002-01-10',
      role_type: :customer,
      status: :active
    )
  end

  scenario 'Staff user sees no sign-up link on staff login page' do
    visit new_user_session_path(role: 'staff')
    expect(page).to have_content('Staff Login')
    expect(page).not_to have_link('Sign up')
  end

  scenario 'Customer user sees sign-up link on customer login page' do
    visit new_user_session_path(role: 'customer')
    expect(page).to have_content('Customer Login')
    expect(page).to have_link('Sign up', href: new_user_registration_path)
  end

  scenario 'Staff can log in from staff login path' do
    visit new_user_session_path(role: 'staff')
    fill_in 'Email', with: staff_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Customer can log in from customer login path' do
    visit new_user_session_path(role: 'customer')
    fill_in 'Email', with: customer_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Customer cannot log in from staff login path' do
    visit new_user_session_path(role: 'staff')
    fill_in 'Email', with: customer_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    expect(page).to have_content('Only staff can log in here.')
  end

  scenario 'Staff cannot log in from customer login path' do
    visit new_user_session_path(role: 'customer')
    fill_in 'Email', with: staff_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    expect(page).to have_content('Only customers can log in here.')
  end

  scenario 'Customer sign-up page is accessible from login page' do
    visit new_user_session_path(role: 'customer')
    click_link 'Sign up'
    expect(page).to have_current_path(new_user_registration_path)
  end

  scenario 'Staff sign-up link is not visible from login page' do
    visit new_user_session_path(role: 'staff')
    expect(page).not_to have_link('Sign up')
  end
end
