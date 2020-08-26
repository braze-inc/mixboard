# frozen_string_literal: true

module Mixboard
  module Sinks
    class DummySink < Sink
      def signal_class
        Mixboard::Signals::DummySignal
      end

      def accept(signal) end
    end
  end
end
