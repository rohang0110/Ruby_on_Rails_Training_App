# spec/system/restaurants_spec.rb
require 'rails_helper'

RSpec.describe 'Restaurants Management', type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'Restaurant Listing (Index)' do
    let_it_be(:open_restaurant) { create(:restaurant, name: 'Open Kitchen', status: :open) }
    let_it_be(:archived_restaurant) { create(:restaurant, name: 'Old Place', status: :archived) }

    it 'displays all restaurants with statuses' do
      visit restaurants_path

      expect(page).to have_content(open_restaurant.name)
      expect(page).to have_content(archived_restaurant.name)

      expect(page).to have_css('.status-badge.open', text: 'OPEN')
      expect(page).to have_css('.status-badge.archived', text: 'ARCHIVED')
    end
  end

  describe 'Creating a Restaurant' do
    before { visit new_restaurant_path }

    def fill_in_restaurant_form(name:, description:, location:, cuisine:)
      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in 'Location', with: location
      fill_in 'Cuisine type', with: cuisine
    end

    context 'with valid input' do
      let(:restaurant_attrs) do
        {
          name: Faker::Restaurant.name,
          description: Faker::Restaurant.description[0..200],
          location: Faker::Address.city,
          cuisine: Faker::Restaurant.type
        }
      end

      it 'creates and redirects with success message' do
        fill_in_restaurant_form(**restaurant_attrs)
        click_button 'Create Restaurant'

        expect(page).to have_content('Restaurant was successfully created')
        expect(page).to have_content(restaurant_attrs[:name])
      end
    end

    context 'with invalid input' do
      it 'shows validation errors' do
        fill_in_restaurant_form(
          name: '',
          description: 'x' * 2001,
          location: '',
          cuisine: ''
        )

        click_button 'Create Restaurant'

        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Location can't be blank")
        expect(page).to have_content("Cuisine type can't be blank")
        expect(page).to have_content('Description is too long')
      end
    end
  end
end
