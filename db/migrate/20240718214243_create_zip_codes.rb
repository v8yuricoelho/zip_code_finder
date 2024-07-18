# frozen_string_literal: true

class CreateZipCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :zip_codes do |t|
      t.string :zip_code, unique: true, null: false
      t.string :address, null: false
      t.string :district, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :ddd, null: false
      t.integer :search_count, null: false, default: 1

      t.timestamps
    end

    add_index :zip_codes, :zip_code, unique: true
  end
end
