# frozen_string_literal: true

module Mixboard
  # Various utility functions
  module UtilityFunctions
    def method_not_implemented_error(name)
      Mixboard::Errors::AbstractNotImplementedError.new(
        class_name: self.class.to_s, entity_name: "method: #{name}"
      )
    end

    def declare_abstract_method_body
      raise method_not_implemented_error(caller_locations(1, 1)[0].label)
    end

    def assert_type(obj, typ)
      return unless !obj.nil? && !obj.is_a?(typ)

      raise Mixboard::Errors::TypeMismatchError.new(expected_type: typ, given_type: obj.class)
    end

    def assert_non_nil_of_type(obj, typ)
      raise Mixboard::Errors::TypeMismatchError.new(expected_type: typ, given_type: obj.class) if obj.nil?

      assert_type(obj, typ)
    end
  end
end
