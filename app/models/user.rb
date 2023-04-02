# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model
  include DummyJsonable

  has_one :bank, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :occupation, dependent: :destroy

  accepts_nested_attributes_for :bank, :address, :occupation

  validates_associated :bank, on: :create
  validates_associated :address, on: :create
  validates_associated :occupation, on: :create

  encrypts :password

  enum gender: { female: "female", male: "male" }

  enum blood_group: {
    "A+" => "positive_a",
    "B+" => "positive_b",
    "AB+" => "positive_ab",
    "O+" => "positive_zero",
    "A-" => "negative_a",
    "B-" => "negative_b",
    "AB-" => "negative_ab",
    "O-" => "negative_zero"
  }

  scope :not_deleted, ->{ where(soft_deleted: false) }
  scope :deleted, ->{ where(soft_deleted: true) }

  scope :by_age, ->(from:, to:){ where(age: (from.to_i..to.to_i)) }
  MIN_AGE = 1
  MAX_AGE = 125

  pg_search_scope :search_by_full_name_and_email,
                  against: [:first_name, :last_name, :maiden_name, :email],
                  using: { tsearch: { prefix: true } }

  def name
    [first_name, last_name].join(" ")
  end
end
