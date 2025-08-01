require 'rails_helper'

RSpec.describe 'User Sign Up', type: :system do
  let(:user_attributes) { attributes_for(:user) }

  def fill_registration_form(attrs = {})
    visit new_user_registration_path

    fill_in 'First name', with: attrs[:first_name] || user_attributes[:first_name]
    fill_in 'Last name', with: attrs[:last_name] || user_attributes[:last_name]
    fill_in 'Email', with: attrs[:email] || user_attributes[:email]
    fill_in 'Password', with: attrs[:password] || user_attributes[:password]
    fill_in 'Password confirmation', with: attrs[:password_confirmation] || user_attributes[:password_confirmation]
    fill_in 'Phone number', with: attrs[:phone_number] || user_attributes[:phone_number]
    fill_in 'Age', with: attrs[:age] || user_attributes[:age]

    dob = attrs[:date_of_birth] || user_attributes[:date_of_birth]
    select dob.day.to_s, from: 'user[date_of_birth(3i)]' if dob
    select dob.month.to_s, from: 'user[date_of_birth(2i)]' if dob
    select dob.year.to_s, from: 'user[date_of_birth(1i)]' if dob
  end

  it 'allows valid sign up' do
    fill_registration_form
    click_button 'Sign up'

    expect(page).to have_content('Welcome to Rails App!')
    expect(page).to have_content("You are signed in as #{user_attributes[:first_name]}!")
  end

  it 'fails with missing required fields' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Phone number can't be blank")
    expect(page).to have_content("Date of birth can't be blank")
    expect(page).to have_content("Age can't be blank")
  end

  it 'fails if password confirmation does not match' do
    fill_registration_form(password_confirmation: 'Mismatch123!')
    click_button 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it 'fails if email is already taken' do
    create(:user, email: user_attributes[:email])
    fill_registration_form
    click_button 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end

  it 'fails with invalid email format' do
    fill_registration_form(email: 'invalid_email')
    click_button 'Sign up'

    expect(page).to have_content('Email is invalid')
  end

  it 'fails if phone number is not exactly 10 digits' do
    fill_registration_form(phone_number: '12345')
    click_button 'Sign up'

    expect(page).to have_content('Phone number must be 10 digits')
  end

  it 'fails if age does not match date of birth' do
    fill_registration_form(age: 10) # Set incorrect age
    click_button 'Sign up'

    expect(page).to have_content('Age does not match your date of birth')
  end
end