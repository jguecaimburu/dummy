# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :company_members, dependent: :destroy
  has_one :address, as: :addressable, inverse_of: :addressable, dependent: :destroy
end
