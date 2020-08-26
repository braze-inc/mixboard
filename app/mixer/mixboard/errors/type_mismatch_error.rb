# frozen_string_literal: true

module Mixboard
  module Errors
    # An error indicating that a signal was provided with an incorrect type.
    class TypeMismatchError < StandardError
      def initialize(expected_type:, given_type:)
        super("Expected signal of type #{expected_type}, but given signal of type #{given_type}")
        @expected_type = expected_type
        @given_type = given_type
      end
    end
  end
end
