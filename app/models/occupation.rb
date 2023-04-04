# frozen_string_literal: true

class Occupation < ApplicationRecord
  belongs_to :user, touch: true

  validates :user, uniqueness: true
  validates :company_name, presence: true
end
