# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ZipCodesController, type: :controller do
  describe 'GET #show' do
    context 'with valid zip code' do
      let(:valid_zip_code) { '12345-678' }
      let(:service_double) { instance_double(FindZipCodeService, call: { 'cep' => valid_zip_code }) }

      it 'redirects to root_path with zip_code_result' do
        allow(FindZipCodeService).to receive(:new).with(zip_code: valid_zip_code).and_return(service_double)

        get :show, params: { zip_code: valid_zip_code }

        expect(response).to redirect_to(root_path(zip_code_result: { 'cep' => valid_zip_code }))
      end
    end

    context 'with invalid zip code' do
      let(:invalid_zip_code) { 'invalid-zip-code' }
      let(:service_double) { instance_double(FindZipCodeService, call: { 'error_message' => 'Invalid zip code' }) }

      it 'redirects to root_path with error message' do
        allow(FindZipCodeService).to receive(:new).with(zip_code: invalid_zip_code).and_return(service_double)

        get :show, params: { zip_code: invalid_zip_code }

        expect(response).to redirect_to(root_path(zip_code_result: { 'error_message' => 'Invalid zip code' }))
      end
    end
  end

  describe 'GET #index' do
    it 'assigns top searched zip codes' do
      top_searched_zip_codes = instance_double(ActiveRecord::Relation)
      allow(ZipCode).to receive(:top_searched).and_return(top_searched_zip_codes)

      get :index
      expect(assigns(:top_searched_zip_codes)).to eq(top_searched_zip_codes)
    end

    it 'assigns top searched zip codes by state' do
      top_searched_zip_codes_by_state = instance_double(ActiveRecord::Relation)
      allow(ZipCode).to receive(:top_searched_by_state).and_return(top_searched_zip_codes_by_state)

      get :index
      expect(assigns(:top_searched_zip_codes_by_state)).to eq(top_searched_zip_codes_by_state)
    end

    it 'assigns amount of zip codes by state' do
      amount_zip_codes_by_state = instance_double(ActiveSupport::HashWithIndifferentAccess)
      allow(ZipCode).to receive(:count_by_state).and_return(amount_zip_codes_by_state)

      get :index
      expect(assigns(:amount_zip_codes_by_state)).to eq(amount_zip_codes_by_state)
    end
  end
end
