# frozen_string_literal: true

class ZipCode < ApplicationRecord
  validates :cep, :address, :district, :state, :city, :ddd, :search_count, presence: true
  validates :cep, uniqueness: true

  UFS = %w[
    AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO
  ].freeze

  def self.top_searched(limit = 3)
    order(search_count: :desc).limit(limit)
  end

  def self.top_searched_by_state
    UFS.map do |state|
      [state, where(state:).order(search_count: :desc).first]
    end
  end

  def self.count_by_state
    counts = Hash.new(0)
    all.find_each { |zipcode| counts[zipcode.state] += 1 }
    counts
  end
end
