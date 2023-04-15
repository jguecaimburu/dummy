# frozen_string_literal: true

module Serviceable
  module Resultable
    class Result
      class Failure < Result
        def success?
          false
        end

        def on_failure
          yield(self)
        end

        def on_success; end
      end
    end
  end
end
