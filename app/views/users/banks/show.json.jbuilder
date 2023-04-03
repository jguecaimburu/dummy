# frozen_string_literal: true

json.cache! @bank do
  json.partial! "users/banks/bank", bank: @bank
  json.url user_bank_url(@user, @bank, format: :json)
end
