# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model, DummyJsonable, Trashable

  has_one :bank, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :occupation, dependent: :destroy
  accepts_nested_attributes_for :bank, :address, :occupation
  validates_associated :bank, on: :create
  validates_associated :address, on: :create
  validates_associated :occupation, on: :create

  encrypts :password

  enum status: { registered: "registered", trashed: "trashed", incinerating: "incinerating" }
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

  scope :by_age, ->(from:, to:) { where(age: (from.to_i..to.to_i)) }
  MIN_AGE = 1
  MAX_AGE = 125

  pg_search_scope :search_by_full_name_and_email,
                  against: %i[first_name last_name maiden_name email],
                  using: { tsearch: { prefix: true } }

  after_commit :purge_cache_later, on: %i[create destroy]

  def name
    [first_name, last_name].join(" ")
  end

  private

  def purge_cache_later
    PurgeCacheJob.perform_async
  end
end
