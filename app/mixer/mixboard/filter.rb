# frozen_string_literal: true

module Mixboard
  # Filters interrupt the flow of signals through the system. You can add filters before or
  # after channels and signal processors
  class Filter
    include Mixboard::UtilityFunctions

    # @return [Class] the Signal subclass that this filter applies to
    def signal_class
      declare_abstract_method_body
    end

    # @param [Signal]
    # @return [Signal,nil] the filtered signal or nil
    def filter(_signal)
      declare_abstract_method_body
    end

    def do_filter(signal)
      assert_non_nil_of_type(signal, signal_class)
      signal = filter(signal)
      assert_type(signal, signal_class)
      signal
    end
  end
end
