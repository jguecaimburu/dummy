# frozen_string_literal: true

class CompanyMember < ApplicationRecord
  belongs_to :company
  belongs_to :user
end
