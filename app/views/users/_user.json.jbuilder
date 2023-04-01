# frozen_string_literal: true

json.merge! user.attributes
json.url user_url(user, format: :json)
