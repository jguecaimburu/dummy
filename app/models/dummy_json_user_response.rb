# frozen_string_literal: true

class DummyJsonUserResponse < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { pending: "pending", processing: "processing", processed: "processed" }

  validates :external_reference, uniqueness: true
  validate :should_be_pending, on: :update, if: -> { processing? && status_changed? }

  after_create_commit :schedule_parsing_job

  private

  def should_be_pending
    errors.add(:status, :not_pending) unless status_was.to_sym == :pending
  end

  def schedule_parsing_job
    ParseDummyJsonUsersJob.perform_async(id)
  end
end
