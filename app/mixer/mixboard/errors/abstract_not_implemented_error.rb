# frozen_string_literal: true

module Mixboard
  module Errors
    # An error meant to indicate that a user tried to call a superclass method that the subclass did not implement.
    class AbstractNotImplementedError < StandardError
      def initialize(class_name:, entity_name:)
        super("#{entity_name} not implemented in abstract class #{class_name}")
        @class_name = class_name
        @entity_name = entity_name
      end
    end
  end
end
