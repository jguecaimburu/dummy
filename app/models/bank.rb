# frozen_string_literal: true

class Bank < ApplicationRecord
  belongs_to :user, touch: true

  validates :user, uniqueness: true
  validates :iban, presence: true
end
