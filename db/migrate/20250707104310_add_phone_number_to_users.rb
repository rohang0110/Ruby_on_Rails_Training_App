# frozen_string_literal: true

# This migration adds a phone_number column to the users table.
# The column is of type string and can store users' contact numbers.
class AddPhoneNumberToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone_number, :string
  end
end
