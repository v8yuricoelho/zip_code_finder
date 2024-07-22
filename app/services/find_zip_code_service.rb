# frozen_string_literal: true

class FindZipCodeService
  def initialize(zip_code:)
    @zip_code = zip_code
  end

  def call
    @response = Faraday.get("https://cep.awesomeapi.com.br/json/#{@zip_code}")
    return process_zip_code if @response.success?

    { 'error_message' => JSON.parse(@response.body)['message'] }
  end

  private

  def process_zip_code
    zip_code = ZipCode.find_or_initialize_by(
      cep: parsed_response['cep']
    ).tap do |object|
      object.address = parsed_response['address']
      object.district = parsed_response['district']
      object.state = parsed_response['state']
      object.city = parsed_response['city']
      object.ddd = parsed_response['ddd']
    end

    zip_code.update(search_count: zip_code.search_count + 1)
    zip_code.attributes
  end

  def parsed_response
    @parsed_response ||= JSON.parse(@response.body)
  end
end
