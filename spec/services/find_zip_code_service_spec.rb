# frozen_string_literal: true

# spec/services/find_zip_code_service_spec.rb

require 'rails_helper'

RSpec.describe FindZipCodeService do
  describe '#call' do
    context 'when the request is successful' do
      let(:zip_code) { '12345-678' }
      let(:response_body) do
        {
          'cep' => '12345678',
          'address' => '123 Main St',
          'district' => 'Downtown',
          'state' => 'NY',
          'city' => 'New York',
          'ddd' => '212'
        }.to_json
      end
      let(:zip_code_result) { described_class.new(zip_code:).call }

      before do
        stub_request(:get, "https://cep.awesomeapi.com.br/json/#{zip_code}")
          .to_return(status: 200, body: response_body)
      end

      it 'creates or updates a ZipCode record and returns its attributes' do
        expect do
          expect(zip_code_result.cep).to eq('12345678')
          expect(zip_code_result.address).to eq('123 Main St')
          expect(zip_code_result.district).to eq('Downtown')
          expect(zip_code_result.state).to eq('NY')
          expect(zip_code_result.city).to eq('New York')
          expect(zip_code_result.ddd).to eq('212')
          expect(zip_code_result.search_count).to eq(1)
        end
      end

      it 'saves record on database' do
        expect do
          described_class.new(zip_code:).call
        end.to change(ZipCode, :count).by(1)
      end

      it 'increments the search_count attribute of the ZipCode record' do
        expect do
          described_class.new(zip_code:).call
        end.to change { ZipCode.first&.search_count.to_i }.by(1)
      end
    end

    context 'when the request fails' do
      let(:zip_code) { '00000-000' }
      let(:error_message) { 'CEP não encontrado' }
      let(:response_body) do
        { 'message' => error_message }.to_json
      end

      before do
        stub_request(:get, "https://cep.awesomeapi.com.br/json/#{zip_code}")
          .to_return(status: 404, body: response_body)
      end

      it 'returns an error message' do
        result = described_class.new(zip_code:).call

        expect(result).to include('error_message' => error_message)
      end

      it 'does not save record on database' do
        expect do
          described_class.new(zip_code:).call
        end.not_to change(ZipCode, :count)
      end
    end
  end
end
