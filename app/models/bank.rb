# frozen_string_literal: true

class Bank < ApplicationRecord
  belongs_to :user, touch: true
end
