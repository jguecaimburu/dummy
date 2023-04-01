# frozen_string_literal: true

json.merge! occupation.attributes
json.url user_occupation_url(@user, format: :json)
