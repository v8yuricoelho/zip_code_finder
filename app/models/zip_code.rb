# frozen_string_literal: true

class ZipCode < ApplicationRecord
  validates :cep, :address, :district, :state, :city, :ddd, :search_count, presence: true
  validates :cep, uniqueness: true
end
