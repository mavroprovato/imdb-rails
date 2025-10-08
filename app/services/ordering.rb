# frozen_string_literal: true

# A class for ordering queries
class Ordering

  def initialize(params)
    @field = parse_field(params)
    @direction = parse_direction(params)
  end

  def order_query(query)
    order = [{ field => direction }]
    query.order(order)
  end

  private

  attr_reader :field, :direction

  def parse_field(params)
    :id
  end

  def parse_direction(params)
    :asc
  end
end
