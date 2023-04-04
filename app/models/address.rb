# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user, touch: true

  validates :user, uniqueness: true
  validates :address, presence: true
  validates :state, presence: true
end
