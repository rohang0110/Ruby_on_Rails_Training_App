# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sign In', type: :system do
  let(:user) { create(:user, password: 'Secure123!') }

  before do
    driven_by(:rack_test)
  end

  it 'signs in with correct credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Secure123!'
    click_button 'Log in'

    expect(page).to have_current_path('/homepage') # Ensure your after_sign_in_path is set
    expect(page).to have_content("You are signed in as #{user.first_name}!")
  end

  it 'fails with incorrect password' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'WrongPassword'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end

  it 'fails with non-existent email' do
    visit new_user_session_path

    fill_in 'Email', with: 'unknown@example.com'
    fill_in 'Password', with: 'SomePassword'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end

  it 'shows remember me option' do
    visit new_user_session_path

    expect(page).to have_field('Remember me')
  end
end
