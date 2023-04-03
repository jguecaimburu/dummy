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

  enum status: { registered: "registered", trashed: "trashed", incinerating: "incinerating" }
  INCINERATION_DELAY = 30.minutes

  scope :by_age, ->(from:, to:) { where(age: (from.to_i..to.to_i)) }
  MIN_AGE = 1
  MAX_AGE = 125

  pg_search_scope :search_by_full_name_and_email,
                  against: %i[first_name last_name maiden_name email],
                  using: { tsearch: { prefix: true } }

  validate :should_be_trashed_before_incineration, on: :update, if: -> { incinerating? && status_changed? }
  
  after_commit :purge_cache_later, on: %i[create destroy]
  after_update_commit :incinerate_later, if: -> { trashed? && status_previously_changed? }


  def self.bulk_trash(selected_ids)
    users = where(id: selected_ids)
    result = transaction do
      users.each { |user| raise ActiveRecord::Rollback unless user.trash }
      true
    end
    result.present?
  end

  def name
    [first_name, last_name].join(" ")
  end

  def trash
    update(status: :trashed)
  end

  def incinerate!
    UserMailer.with(user: self).incinerated.deliver_now
    destroy!
  end

  private

  def should_be_trashed_before_incineration
    errors.add(:status, :was_not_active) unless status_was.to_sym == :trashed
  end

  def incinerate_later
    UserIncinerationJob.perform_in(INCINERATION_DELAY, id)
  end

  def purge_cache_later
    PurgeCacheJob.perform_async
  end
end
