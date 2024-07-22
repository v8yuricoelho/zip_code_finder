# frozen_string_literal: true

FactoryBot.define do
  factory :zip_code do
    cep { Faker::Address.unique.zip_code }
    address { Faker::Address.street_name }
    district { 'Springfield' }
    state { %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].sample }
    city { Faker::Address.city }
    ddd { '73' }
    search_count { 0 }
  end
end
