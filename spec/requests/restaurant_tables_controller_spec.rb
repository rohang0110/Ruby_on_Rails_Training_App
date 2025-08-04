# spec/requests/tables_spec.rb
require 'rails_helper'

RSpec.describe 'Table Requests', type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:table) { create(:table, restaurant:) }

  let(:valid_attributes) do
    {
      table_number: Faker::Number.unique.between(from: 1, to: 100),
      seats: Faker::Number.between(from: 2, to: 10),
      status: %w[available occupied reserved].sample
    }
  end

  describe 'GET /restaurants/:restaurant_id/tables' do
    it 'renders the table list page' do
      get restaurant_tables_path(restaurant)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /restaurants/:restaurant_id/tables' do
    it 'creates a new table' do
      expect do
        post restaurant_tables_path(restaurant), params: { table: valid_attributes }
      end.to change(Table, :count).by(1)
      expect(response).to redirect_to(restaurant_tables_path(restaurant))
    end
  end

  describe 'PATCH /restaurants/:restaurant_id/tables/:id' do
    it 'updates the table details' do
      patch restaurant_table_path(restaurant, table), params: {
        table: { table_number: 99 }
      }
      expect(response).to redirect_to(restaurant_tables_path(restaurant))
      expect(table.reload.table_number).to eq(99)
    end
  end

  describe 'DELETE /restaurants/:restaurant_id/tables/:id' do
    it 'deletes the table' do
      expect do
        delete restaurant_table_path(restaurant, table)
      end.to change(Table, :count).by(-1)
      expect(response).to redirect_to(restaurant_tables_path(restaurant))
    end
  end
end
