# frozen_string_literal: true

class Occupation < ApplicationRecord
  belongs_to :user, touch: true
end
