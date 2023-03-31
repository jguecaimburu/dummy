# frozen_string_literal: true

class User < ApplicationRecord
  include DummyJsonable

  has_one :bank, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :occupation, dependent: :destroy

  accepts_nested_attributes_for :bank, :address, :occupation
  
  validates_associated :bank, on: :create
  validates_associated :address, on: :create
  validates_associated :occupation, on: :create

  encrypts :password

  def name
    [first_name, last_name].join(" ")
  end
end
