# frozen_string_literal: true

module Mixboard
  # A sink is anything that accepts signals of a certain type.
  class Sink
    include Mixboard::UtilityFunctions

    def signal_class
      declare_abstract_method_body
    end

    def accept(_signal)
      declare_abstract_method_body
    end

    def do_accept(signal)
      assert_non_nil_of_type(signal, signal_class)
      accept(signal)
    end
  end
end
