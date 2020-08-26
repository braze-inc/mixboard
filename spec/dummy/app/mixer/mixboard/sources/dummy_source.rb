# frozen_string_literal: true

module Mixboard
  module Sources
    class DummySource < Source
      def signal_class
        Mixboard::Signals::DummySignal
      end

      def log
        emit(Mixboard::Signals::DummySignal.new)
      end
    end
  end
end
