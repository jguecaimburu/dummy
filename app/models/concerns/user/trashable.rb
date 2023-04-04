# frozen_string_literal: true

class User
  module Trashable
    extend ActiveSupport::Concern

    included do
      INCINERATION_DELAY = 30.minutes
      validate :should_be_trashed_before_incineration, on: :update, if: :incinerating?
      after_update_commit :incinerate_later, if: -> { trashed? && status_previously_changed? }
    end

    class_methods do
      def bulk_trash(selected_ids)
        users = where(id: selected_ids)
        result = transaction do
          users.each { |user| raise ActiveRecord::Rollback unless user.trash }
          true
        end
        result.present?
      end
    end

    def trash
      update(status: :trashed)
    end
  
    def incinerate!
      UserMailer.with(user: self).incinerated.deliver_now
      destroy!
    end

    private

    def should_be_trashed_before_incineration
      errors.add(:status, :was_not_trashed) unless status_was.to_sym == :trashed
    end
  
    def incinerate_later
      UserIncinerationJob.perform_in(INCINERATION_DELAY, id)
    end
  end
end