# frozen_string_literal: true

class UserIncinerationJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    return unless user.trashed?
    
    user.with_lock { user.incinerating! }

    user.incinerate!
  end
end
