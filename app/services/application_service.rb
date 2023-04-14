# frozen_string_literal: true

class ApplicationService
  def initialize(**); end

  def success(metadata = {})
    Result.success(metadata)
  end

  def failure(metadata = {})
    Result.failure(metadata)
  end
end
