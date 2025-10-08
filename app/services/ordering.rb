# frozen_string_literal: true

# A class for ordering queries
class Ordering

  def initialize(field, direction)
    @field = parse_field(field)
    @direction = parse_direction(direction)
  end

  def order_query(query)
    query.order([{ field => direction }])
  end

  private

  attr_reader :field, :direction

  def parse_field(field)
    :id
  end

  def parse_direction(direction)
    :asc
  end
end
