# frozen_string_literal: true

module Mixboard
  # Signal processors accept signals of a certain type and emit signals of a certain type.
  # The are used for transforming signals from one type to another.
  class SignalProcessor
    include Mixboard::Filterable
    include Mixboard::UtilityFunctions

    # @return [Class] the Signal subclass that this filter applies to
    def input_signal_class
      declare_abstract_method_body
    end

    # @return [Class] the Signal subclass that this filter applies to
    def output_signal_class
      declare_abstract_method_body
    end

    # @param [Signal]
    # @return [Signal,nil] the filtered signal or nil
    def transform(_signal)
      declare_abstract_method_body
    end

    def do_transform(signal)
      assert_non_nil_of_type(signal, input_signal_class)
      signal = with_filters(signal) do
        transform(signal)
      end
      assert_type(signal, output_signal_class)
      signal
    end
  end
end
