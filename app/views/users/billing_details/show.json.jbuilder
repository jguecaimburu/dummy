# frozen_string_literal: true

# TODO: Move partials to proper controllers

json.bank do
  json.partial! "users/billing_details/bank", bank: @bank
end

json.address do
  json.partial! "users/addresses/address", address: @address
end

json.url user_billing_detail_url(@user, format: :json)
