# frozen_string_literal: true

class UserSearch
  include ActiveModel::Model

  attr_accessor :search_term, :from_age, :to_age, :gender

  def initialize(params)
    super
    @from_age ||= User::MIN_AGE
    @to_age ||= User::MAX_AGE
  end

  def users
    users = User.registered
    users = users.where(gender:) if gender.present?
    users = users.by_age(from: from_age, to: to_age)
    users = users.search_by_full_name_and_email(search_term) if search_term.present?
    users
  end

  def self.genders
    User.genders
  end
end
