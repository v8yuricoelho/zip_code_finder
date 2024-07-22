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

  let!(:zip_code1) { FactoryBot.create(:zip_code, search_count: 10, state: 'BA') }
  let!(:zip_code2) { FactoryBot.create(:zip_code, search_count: 8, state: 'PE') }
  let!(:zip_code3) { FactoryBot.create(:zip_code, search_count: 5, state: 'SP') }
  let!(:zip_code4) { FactoryBot.create(:zip_code, search_count: 1, state: 'BA') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cep) }
    it { is_expected.to validate_presence_of(:district) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:ddd) }
    it { is_expected.to validate_presence_of(:search_count) }

    it { is_expected.to validate_uniqueness_of(:cep).case_insensitive }
  end

  describe '.top_searched' do
    it 'returns top searched zip codes' do
      top_searched = described_class.top_searched(3)

      expect(top_searched).to eq([zip_code1, zip_code2, zip_code3])
    end
  end

  describe '.top_searched_by_state' do
    it 'returns top searched zip code for each state' do
      top_searched_by_state = described_class.top_searched_by_state

      zip_code_ba = top_searched_by_state.find { |item| item[0] == 'BA' }[1]
      expect(zip_code_ba).to eq(zip_code1)

      zip_code_pe = top_searched_by_state.find { |item| item[0] == 'PE' }[1]
      expect(zip_code_pe).to eq(zip_code2)

      zip_code_sp = top_searched_by_state.find { |item| item[0] == 'SP' }[1]
      expect(zip_code_sp).to eq(zip_code3)
    end
  end

  describe '.count_by_state' do
    it 'returns counts of zip codes by state' do
      count_by_state = described_class.count_by_state

      expect(count_by_state['BA']).to eq(2)
      expect(count_by_state['PE']).to eq(1)
      expect(count_by_state['SP']).to eq(1)
    end
  end
end
