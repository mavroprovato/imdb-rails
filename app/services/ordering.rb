# frozen_string_literal: true

# A class for ordering queries
class Ordering
  # The order field parameter name
  ORDERING_PARAM = 'ordering'
  # The ordering direction parameter name
  ORDERING_DIRECTION_PARAM = 'direction'
  # Ordering direction values
  ORDERING_DIRECTION_VALUES = %w[asc desc].freeze

  # Initialize the ordering.
  #
  # @param params [ActionController::Params] The request parameters.
  # @param ordering_fields List[Symbol] The ordering fields.
  # @param default_ordering_field Symbol The default ordering field.
  def initialize(params, ordering_fields, default_ordering_field)
    @ordering_fields = ordering_fields
    @default_ordering_field = default_ordering_field
    @field = parse_field(params)
    @direction = parse_direction(params)
  end

  # Order the query.
  #
  # @param query ActiveRecord::Relation The query.
  # @return ActiveRecord::Relation The ordered query.
  def order_query(query)
    order = [{ id: :asc }]
    order.unshift({ field => direction }) if field.present?
    query.order(order)
  end

  private

  attr_reader :ordering_fields, :default_ordering_field, :field, :direction

  def parse_field(params)
    field = params[ORDERING_PARAM]&.to_sym
    return field if ordering_fields.present? && ordering_fields&.include?(field)

    default_ordering_field
  end

  def parse_direction(params)
    return :asc unless ORDERING_DIRECTION_VALUES.include? params[ORDERING_DIRECTION_PARAM]

    params[ORDERING_DIRECTION_PARAM].to_sym
  end
end
