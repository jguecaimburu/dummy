# frozen_string_literal: true

class ParseDummyJsonUsersJob < ApplicationJob
  def perform(dummy_json_user_response_id)
    dummy_json_user_response = DummyJsonUserResponse.find(dummy_json_user_response_id)
    return unless dummy_json_user_response.pending?

    dummy_json_user_response.with_lock do
      dummy_json_user_response.processing!
      User.create_from_dummy_json_response!(dummy_json_user_response)
      dummy_json_user_response.processed!
    end
  end
end
