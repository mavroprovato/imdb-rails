# frozen_string_literal: true

# The genre controller
class GenresController < ApplicationController
  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE = 100

  def index
    render json: paginated_results
  end

  def show
    render json: model.find(params[:id])
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
    query.limit(per_page).offset(offset)
  end

  def per_page
    per_page = params.fetch(:per_page, 10).to_i
    return DEFAULT_PAGE_SIZE if per_page.zero? || per_page.negative?

    [MAX_PAGE_SIZE, per_page].min
  end

  def offset
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1

    (page - 1) * per_page
  end

  def total
    model.count
  end
end
