# frozen_string_literal: true

class ZipCode < ApplicationRecord
  validates :zip_code, :address, :district, :state, :city, :ddd, :search_count, presence: true
  validates :zip_code, uniqueness: true
end
