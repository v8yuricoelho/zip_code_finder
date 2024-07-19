# frozen_string_literal: true

class ZipCode < ApplicationRecord
  validates :cep, :address, :district, :state, :city, :ddd, :search_count, presence: true
  validates :cep, uniqueness: true

  def self.top_searched(limit = 3)
    order(search_count: :desc).limit(limit)
  end
end
