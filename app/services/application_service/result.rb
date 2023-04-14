# frozen_string_literal: true

class ApplicationService
  class Result
    def self.success(metadata = {})
      Success.new(metadata:)
    end

    def self.failure(metadata = {})
      Failure.new(metadata:)
    end

    attr_reader :metadata

    def initialize(metadata:)
      @metadata = metadata&.symbolize_keys || {}
    end

    def success?
      raise "Should implement success?"
    end

    def on_success
      raise "Implement on_success"
    end

    def on_failure
      raise "Implement on_failure"
    end

    private

    def method_missing(name, *_args, **_kwargs, &)
      if metadata.key?(name)
        metadata.fetch(name)
      else
        super(&)
      end
    end

    def respond_to_missing?(name, _include_private = false)
      metadata.key?(name) || super
    end
  end
end
