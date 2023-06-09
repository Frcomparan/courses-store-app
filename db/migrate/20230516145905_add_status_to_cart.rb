# frozen_string_literal: true

class AddStatusToCart < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :status, :integer, default: 0
    add_reference :carts, :user
  end
end
