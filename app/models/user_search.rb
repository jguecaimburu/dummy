# frozen_string_literal: true

class UserSearch
  include ActiveModel::Model

  attr_accessor :search_term, :from_age, :to_age, :gender

  def users
    users = User.registered
    users = users.where(gender:) if gender.present?
    users = users.by_age(from: from_age, to: to_age) if from_age.present? || to_age.present?
    users = users.by_full_name_and_email(search_term) if search_term.present?
    users
  end

  def self.genders
    User.genders
  end

  def params
    [search_term, from_age, to_age, gender].compact_blank
  end
end
