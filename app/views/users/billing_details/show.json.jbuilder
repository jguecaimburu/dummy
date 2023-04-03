# frozen_string_literal: true

# TODO: Move partials to proper controllers

json.cache! [@bank, :billing_details] do
  json.bank do
    json.partial! "users/billing_details/bank", bank: @bank
  end
end

json.cache! [@address, :billing_details] do
  json.address do
    json.partial! "users/addresses/address", address: @address
  end
end

json.url user_billing_detail_url(@user, format: :json)
