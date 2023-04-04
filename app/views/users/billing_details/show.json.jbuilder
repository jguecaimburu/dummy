# frozen_string_literal: true

json.cache! [@bank, :billing_details] do
  json.bank do
    json.partial! "users/banks/bank", bank: @bank
  end
end

json.cache! [@address, :billing_details] do
  json.address do
    json.partial! "users/addresses/address", address: @address
  end
end

json.url user_billing_detail_url(@user, format: :json)
