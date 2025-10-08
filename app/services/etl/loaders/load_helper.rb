# frozen_string_literal: true

module Etl
  module Loaders
    # Contains helper methods for loaders
    module LoadHelper
      # Transform a string value to a boolean. Returns +true+ if the input value is +1+.
      #
      # @param value [String] The input value.
      # @return [Boolean] The boolean value.
      def transform_boolean?(value)
        value == '1'
      end

      # Transform a string value to an integer. No checks if the value is nil are performed.
      #
      # @param value [String] The input value.
      # @return [Integer] The integer value.
      def transform_integer(value)
        value.to_i
      end

      # Transform a nilable string value to an integer.
      #
      # @param value [String] The input value.
      # @return [Int, nil] The integer value, or nil.
      def transform_nilable_integer(value)
        value == NULL_VALUE ? nil : value.to_i
      end

      # Transform a nilable string value
      #
      # @param value [String] The string value.
      # @return [String, nil] The string value, or nil.
      def transform_nilable_string(value)
        value == NULL_VALUE ? nil : value
      end

      # Transform a nilable string array value
      #
      # @param value [String] The string value.
      # @return [Array<String>, nil] The string array value, or nil.
      def transform_nilable_string_array(value)
        value == NULL_VALUE ? [] : value.split("\u0002")
      end

      # Load the unique values for a column from a batch of data.
      #
      # @param batch [Array<Hash>] The data to load.
      # @param column [Symbol] The column.
      # @param multivalued [Boolean] True if the column is multivalued (comma separated), false otherwise.
      def read_unique_values(batch, column, multivalued: false)
        batch.reject { |row| row[column] == NULL_VALUE }.each_with_object(Set.new) do |row, set|
          multivalued ? row[column].split(',').each { |value| set << value } : set << row[column]
        end
      end

      # Return the loaded values for a model
      #
      # @param model [Class] The model for the values.
      # @param unique_attribute [Symbol] The unique attribute for the model.
      # @param unique_values [Array<String>]The unique values of the attribute to load.
      # @return [Hash<String, Integer>] A hash that maps the unique attribute value to the internal database identifier.
      def loaded_values(model, unique_attribute, unique_values)
        model.where(unique_attribute => unique_values).pluck(:id, unique_attribute)
             .each_with_object({}) do |(id, attribute), hash|
          hash[attribute] = id
        end
      end
    end
  end
end
