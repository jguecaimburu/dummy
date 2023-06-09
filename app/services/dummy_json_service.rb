# frozen_string_literal: true

class DummyJsonService
  include Serviceable

  BASE_URI = URI("https://dummyjson.com")

  attr_reader :http_client

  def initialize(http_client: nil)
    @http_client = http_client || Faraday
  end

  def users_data(skip: 0, limit: 10)
    get("/users", params: { skip:, limit: })
  end

  def get(resource_path, params: {})
    uri = BASE_URI.merge(resource_path)
    response = http_client.get(uri, params, { "Accept" => "application/json" })
    if response.success?
      success(response: JSON.parse(response.body))
    else
      msg = "Failed GET request. #{{ api_endpoint: uri.to_s, params:, response: response.to_h }.to_json}"
      failure(error_message: msg)
    end
  end
end
