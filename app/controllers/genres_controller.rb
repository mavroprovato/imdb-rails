# frozen_string_literal: true

# The genre controller
class GenresController < ApplicationController
  def index
    render json: paginated_results
  end

  protected

  def model
    Genre
  end

  private

  def paginated_results
    {
      total:,
      results:
    }
  end

  def results
    paginate_query order_query model
  end

  def order_query(query)
    query.order(:id)
  end

  def paginate_query(query)
    query.limit(10).offset(0)
  end

  def total
    model.count
  end
end
