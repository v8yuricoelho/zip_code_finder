# frozen_string_literal: true

class ZipCodesController < ApplicationController
  def show
    @zip_code = FindZipCodeService.new(zip_code: params[:zip_code]).call
    render json: @zip_code, status: :ok
  end
end
