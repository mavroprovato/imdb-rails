# frozen_string_literal: true

# Base controller for CRUD API endpoints
class BaseCrudController < ApplicationController
  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE = 100

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: paginated_results
  end

  def show
    render json: model.find(params[:id])
  end

  protected

  def model
    raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
  end

  private

  def record_not_found
    render json: { errors: ["#{model} with id #{params[:id]} not found"] }, status: :not_found
  end

  def paginated_results
    {
      total:,
      results:
    }
  end

  def results
    paginate_query order_query model
  end

  def total
    model.count
  end

  def paginate_query(query)
    query.limit(per_page).offset(offset)
  end

  def per_page
    per_page = params.fetch(:per_page, DEFAULT_PAGE_SIZE).to_i
    return DEFAULT_PAGE_SIZE if per_page.zero? || per_page.negative?

    [MAX_PAGE_SIZE, per_page].min
  end

  def offset
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1

    (page - 1) * per_page
  end

  def order_query(query)
    query.order(:id)
  end
end
