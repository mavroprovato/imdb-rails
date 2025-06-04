# frozen_string_literal: true

# Base controller for CRUD API endpoints
class BaseCrudController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: { total:, results: blueprint.render_as_hash(results, view:) }
  end

  def show
    render json: blueprint.render(model.find(params[:id]), view:)
  end

  protected

  def model
    raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
  end

  def include
    []
  end

  def view; end

  def blueprint
    "#{model}Blueprint".constantize
  end

  private

  def total
    model.count
  end

  def results
    paginate_query order_query list_query
  end

  def paginate_query(query)
    Paginator.new(params['page'], params['per_page']).paginate_query(query)
  end

  def order_query(query)
    query.order(:id)
  end

  def list_query
    return model if include.empty?

    model.includes(*include)
  end

  def record_not_found
    render json: { errors: ["#{model} with id #{params[:id]} not found"] }, status: :not_found
  end
end
