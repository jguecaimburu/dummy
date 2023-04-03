# frozen_string_literal: true

json.cache! @address do
  json.partial! "users/addresses/address", address: @address
  json.url user_address_url(@user, @address, format: :json)
end
