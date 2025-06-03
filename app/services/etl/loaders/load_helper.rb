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
    end
  end
end
