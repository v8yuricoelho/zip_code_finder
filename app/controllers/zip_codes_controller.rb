# frozen_string_literal: true

class ZipCodesController < ApplicationController
  def show
    @zip_code = FindZipCodeService.new(zip_code: params[:zip_code]).call

    redirect_to root_path(zip_code_result: @zip_code)
  end

  def index
    @zip_code_result = params[:zip_code_result]
    @top_searched_zip_codes = ZipCode.top_searched
  end
end
