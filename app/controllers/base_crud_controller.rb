# frozen_string_literal: true

# Base controller for CRUD API endpoints
class BaseCrudController < ApplicationController
  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE = 100

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: { total:, results: }
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

  def results
    Paginator.new(params['page'], params['per_page']).paginate_query order_query model
  end

  def total
    model.count
  end

  def order_query(query)
    query.order(:id)
  end
end
