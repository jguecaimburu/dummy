# frozen_string_literal: true

class PurgeCacheJob < ApplicationJob
  def perform
    Rails.cache.clear
  end
end
