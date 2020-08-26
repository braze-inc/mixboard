# frozen_string_literal: true

module Mixboard
  module SignalProcessors
    class DummySignalProcessor < SignalProcessor
      def input_signal_class
        Mixboard::Signals::DummySignal
      end

      def output_signal_class
        Mixboard::Signals::DummySignal
      end

      def transform(signal)
        signal
      end
    end
  end
end
