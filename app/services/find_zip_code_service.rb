# frozen_string_literal: true

class FindZipCodeService
  def initialize(zip_code:)
    @zip_code = zip_code
  end

  def call
    response = Faraday.get("https://cep.awesomeapi.com.br/json/#{@zip_code}")
    return JSON.parse(response.body) if response.success?

    { 'error_message' => JSON.parse(response.body)['message'] }
  end
end
