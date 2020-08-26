# frozen_string_literal: true

module Mixboard
  module Filters
    class DummyFilter < Filter
      def signal_class
        Signals::DummySignal
      end

      def filter(signal)
        signal
      end
    end
  end
end
