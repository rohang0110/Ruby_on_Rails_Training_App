class AddCustomerFieldsToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :customer_name, :string
    add_column :reservations, :customer_contact, :string
  end
end
