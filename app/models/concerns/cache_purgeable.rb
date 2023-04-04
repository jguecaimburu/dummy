# frozen_string_literal: true

module CachePurgeable
  extend ActiveSupport::Concern

  included do
    after_commit :purge_cache_later, on: %i[create destroy]
  end

  private

  def purge_cache_later
    PurgeCacheJob.perform_async
  end
end