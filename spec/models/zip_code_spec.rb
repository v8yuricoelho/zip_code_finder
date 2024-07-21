# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ZipCode, type: :model do
  subject do
    described_class.new(
      cep: '41100715',
      address: '1ª Travessa São José',
      district: 'Pernambués',
      state: 'BA',
      city: 'Salvador',
      ddd: '71',
      search_count: 1
    )
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cep) }
    it { is_expected.to validate_presence_of(:district) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:ddd) }
    it { is_expected.to validate_presence_of(:search_count) }

    it { is_expected.to validate_uniqueness_of(:cep).case_insensitive }
  end
end
