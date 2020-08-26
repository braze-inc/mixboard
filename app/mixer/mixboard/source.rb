# frozen_string_literal: true

module Mixboard
  # A source is anything that emits signals of a certain type.
  class Source
    include Mixboard::UtilityFunctions

    def signal_class
      declare_abstract_method_body
    end

    def emit(signal)
      assert_non_nil_of_type(signal, signal_class)
      Mixer.instance.accept(signal, self)
    end
  end
end
