json.partial! "users/occupations/occupation", occupation: @occupation
json.url user_occupation_url(@user, @occupation, format: :json)
