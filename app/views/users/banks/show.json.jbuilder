# frozen_string_literal: true

json.partial! "users/banks/bank", bank: @bank
json.url user_bank_url(@user, @bank, format: :json)
