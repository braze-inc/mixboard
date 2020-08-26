# frozen_string_literal: true

module Mixboard
  # A specific end-to-end route from a source to a sink.
  class Channel
    include Mixboard::Filterable
    include Mixboard::UtilityFunctions

    attr_reader :source_class

    def add_source(source_class)
      assert_non_nil_of_type(source_class, Class)
      @source_class = source_class
      self
    end

    def add_sink(sink)
      assert_non_nil_of_type(sink, Sink)
      @sink = sink
      self
    end

    def add_signal_processor(signal_processor)
      assert_non_nil_of_type(signal_processor, SignalProcessor)
      signal_processors.append(signal_processor)
      self
    end

    def accept(signal)
      signal = with_filters(signal) do
        signal_processors.reduce(signal) do |current_signal, signal_processor|
          signal_processor.do_transform(current_signal)
        end
      end
      @sink.do_accept(signal) unless signal.nil?
    end

    private

    def signal_processors
      @signal_processors ||= []
    end
  end
end
