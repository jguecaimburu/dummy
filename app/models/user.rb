# frozen_string_literal: true

class User < ApplicationRecord
  include DummyJsonable

  has_one :bank, dependent: :destroy
  has_one :company_member, dependent: :destroy
  has_one :company, through: :company_member
  has_one :address, as: :addressable, inverse_of: :addressable, dependent: :destroy

  encrypts :password
end
