# frozen_string_literal: true

module Serviceable
  module Resultable
    extend ActiveSupport::Concern

    def success(metadata = {})
      Result.success(metadata)
    end

    def failure(metadata = {})
      Result.failure(metadata)
    end
  end
end
