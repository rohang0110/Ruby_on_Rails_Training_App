# spec/requests/menu_item_spec.rb
require 'rails_helper'

RSpec.describe 'MenuItem Requests', type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu_item) { create(:menu_item, restaurant:) }

  let(:valid_attributes) do
    {
      item_name: Faker::Food.dish,
      description: Faker::Food.description,
      price: Faker::Commerce.price(range: 5.0..25.0),
      category: %w[starter main dessert drink].sample,
      available: true
    }
  end

  describe 'GET /restaurants/:id/menu' do
    it 'renders the menu items list' do
      get restaurant_menu_items_path(restaurant)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /restaurants/:id/menu' do
    it 'creates a new menu item' do
      expect do
        post restaurant_menu_items_path(restaurant), params: { menu_item: valid_attributes }
      end.to change(MenuItem, :count).by(1)
      expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
    end
  end

  describe 'PATCH /restaurants/:id/menu/:id' do
    it 'updates the menu item' do
      patch restaurant_menu_item_path(restaurant, menu_item), params: {
        menu_item: { item_name: 'Updated Dish' }
      }
      expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
      expect(menu_item.reload.item_name).to eq('Updated Dish')
    end
  end

  describe 'DELETE /restaurants/:id/menu/:id' do
    it 'deletes the menu item' do
      expect do
        delete restaurant_menu_item_path(restaurant, menu_item)
      end.to change(MenuItem, :count).by(-1)
      expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
    end
  end
end
