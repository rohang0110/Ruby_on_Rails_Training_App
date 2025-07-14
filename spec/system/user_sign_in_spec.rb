require 'rails_helper'

RSpec.describe 'User Sign In', type: :system do
  let(:user) { create(:user, password: 'Secure123!') } # Ensure password is generated

  def fill_sign_in_form(email:, password:)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
  end

  it 'signs in with valid credentials' do
    fill_sign_in_form(email: user.email, password: 'Secure123!')
    click_button 'Log in'

    expect(page).to have_current_path('/homepage') # Ensure after_sign_in_path is configured correctly
    expect(page).to have_content("You are signed in as #{user.first_name}!")
  end

  it 'fails with invalid password' do
    fill_sign_in_form(email: user.email, password: 'WrongPassword')
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end

  it 'fails with wrong email' do
    fill_sign_in_form(email: 'wrongemail@example.com', password: 'Secure123!')
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end

  it 'fails with blank email and password' do
    visit new_user_session_path
    click_button 'Log in'

    expect(page).to have_content("Invalid Email or password.")
  end

  it 'shows remember me option' do
    visit new_user_session_path

    expect(page).to have_field('Remember me')
  end

  it 'locks the account after multiple failed attempts' do
    Devise.maximum_attempts.times do
      fill_sign_in_form(email: user.email, password: 'WrongPassword')
      click_button 'Log in'
    end

    fill_sign_in_form(email: user.email, password: 'Secure123!')
    click_button 'Log in'

    expect(page).to have_content('Your account is locked.')
  end

  it 'allows sign in after account unlock' do
    # Lock the account
    Devise.maximum_attempts.times do
      fill_sign_in_form(email: user.email, password: 'WrongPassword')
      click_button 'Log in'
    end

    # Unlock the account (simulate unlock via admin or link)
    user.unlock_access!

    fill_sign_in_form(email: user.email, password: 'Secure123!')
    click_button 'Log in'

    expect(page).to have_current_path('/homepage')
    expect(page).to have_content("You are signed in as #{user.first_name}!")
  end
end