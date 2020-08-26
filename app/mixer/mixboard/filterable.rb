# frozen_string_literal: true

module Mixboard
  # A mixin for anything that can have a filter added before/after it.
  module Filterable
    include Mixboard::UtilityFunctions

    def add_before_filter(filter)
      before_filters.append(filter)
      self
    end

    def add_after_filter(filter)
      after_filters.append(filter)
      self
    end

    def with_filters(signal, &block)
      signal = run_filters(signal, before_filters)
      return nil if signal.nil?

      block.call(signal)
      run_filters(signal, after_filters)
    end

    private

    def run_filters(signal, filters)
      filters.reduce(signal) do |current_signal, filter|
        return nil if current_signal.nil?

        assert_non_nil_of_type(current_signal, filter.signal_class)
        filter.do_filter(current_signal)
      end
    end

    def before_filters
      @before_filters ||= []
    end

    def after_filters
      @after_filters ||= []
    end
  end
end
