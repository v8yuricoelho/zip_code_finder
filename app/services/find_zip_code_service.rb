# frozen_string_literal: true

class FindZipCodeService
  def initialize(zip_code:)
    @zip_code = zip_code
  end

  def call
    response = Faraday.get("https://cep.awesomeapi.com.br/json/#{@zip_code}")
    JSON.parse(response.body)
  end
end
