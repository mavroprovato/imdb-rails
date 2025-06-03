# frozen_string_literal: true

module Etl
  module Loaders
    # Contains helper methods for loaders
    module LoadHelper
      # Transform a string value to a boolean. Returns +true+ if the input value is +1+.
      #
      # @param [String] value The input value.
      # @return [Boolean] The boolean value.
      def transform_boolean(value)
        value == '1'
      end

      # Transform a string value to an integer. No checks if the value is nil are performed.
      #
      # @param [String] value The input value.
      # @return [Int] The integer value.
      def transform_integer(value)
        value.to_i
      end

      # Transform a nilable string value to an integer.
      #
      # @param [String] value The input value.
      # @return [Int, nil] The integer value, or nil.
      def transform_nilable_integer(value)
        value == NULL_VALUE ? nil : value.to_i
      end
    end
  end
end
