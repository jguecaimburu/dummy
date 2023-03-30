# frozen_string_literal: true

class FetchDummyJsonUsersJob < ApplicationJob
  MAX_RETRIES = 2
  RETRY_DELAY = 5.minutes

  def perform(skip_users = 0, limit_users = 10, retries = 0)
    @skip_users = skip_users
    @limit_users = limit_users
    @retries = retries

    users_data = fetch_dummy_json_data
    return if users_data.empty?

    bulk_create_users(users_data)

    return if users_data["total"] <= @skip_users + @limit_users

    schedule_next_batch_fetching
  end

  def fetch_dummy_json_data
    DummyJsonService.new.users_data
  rescue RuntimeError => e
    logger.error e.message
    attempt_retry
    {}
  end

  def bulk_create_users(users_data)
    users_data["users"].each do |user_data|
      User.create_from_dummy_json_data!(user_data)
    rescue ActiveRecord::RecordInvalid => e
      logger.error
      "Failed to create user and associated records. #{
            { data: user_data, error: e.message }.to_json
          }"
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
