# frozen_string_literal: true

class FetchDummyJsonUsersJob < ApplicationJob
  MAX_RETRIES = 2
  RETRY_DELAY = 5.minutes

  def perform(skip_users = 0, limit_users = 10, retries = 0)
    @skip_users = skip_users
    @limit_users = limit_users
    @retries = retries

    result = fetch_dummy_json_data
    return unless result.success?
    return if result.response["total"] <= @skip_users + @limit_users

    schedule_next_batch_fetching
  end

  def fetch_dummy_json_data
    result = DummyJsonService.new.users_data(skip: @skip_users, limit: @limit_users)

    result.on_success do |r|
      bulk_create_user_responses(r.response)
    end

    result.on_failure do |r|
      logger.error r.error_message
      attempt_retry
    end

    result
  end

  def bulk_create_user_responses(users_data)
    users_data["users"].each do |user_data|
      next if DummyJsonUserResponse.find_by(external_reference: user_data["id"])

      DummyJsonUserResponse.create!(data: user_data, external_reference: user_data["id"])
    end
  end

  def schedule_next_batch_fetching
    next_skip = @skip_users + @limit_users
    self.class.perform_async(next_skip, @limit_users)
  end

  def attempt_retry
    return if @retries == MAX_RETRIES

    @retries += 1
    self.class.perform_in(RETRY_DELAY, @skip_users, @limit_users, @retries)
  end
end
