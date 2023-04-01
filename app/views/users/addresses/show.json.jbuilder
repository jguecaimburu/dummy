json.partial! "users/addresses/address", address: @address
json.url user_address_url(@user, @address, format: :json)
