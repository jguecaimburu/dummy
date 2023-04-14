# frozen_string_literal: true

class ApplicationService
  class Result
    class Success < Result
      def success?
        true
      end

      def on_success
        yield(self)
      end

      def on_failure; end
    end
  end
end
