# frozen_string_literal: true

json.cache! @user do
  json.partial! "users/user", user: @user
end
