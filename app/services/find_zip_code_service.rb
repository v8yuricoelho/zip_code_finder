# frozen_string_literal: true

class FindZipCodeService
  def initialize(zip_code:)
    @zip_code = zip_code
  end

  def call
    response = Faraday.get("https://cep.awesomeapi.com.br/json/#{@zip_code}")
    return process_zip_code(response) if response.success?

    { 'error_message' => JSON.parse(response.body)['message'] }
  end

  private

  def process_zip_code(response)
    parsed_response = JSON.parse(response.body)

    zip_code = ZipCode.find_or_create_by(
      cep: parsed_response['cep'],
      address: parsed_response['address'],
      district: parsed_response['district'],
      state: parsed_response['state'],
      city: parsed_response['city'],
      ddd: parsed_response['ddd']
    )

    zip_code.update(search_count: zip_code.search_count + 1)
    zip_code.attributes
  end
end
