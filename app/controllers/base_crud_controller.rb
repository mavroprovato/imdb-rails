# frozen_string_literal: true

# Base controller for CRUD API endpoints
class BaseCrudController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: { total:, results: }
  end

  def show
    render json: blueprint.render(model.find(params[:id]), view:)
  end

  protected

  # The model for the controller. This method must be implemented by subclasses.
  #
  # @return ApplicationRecord The model for the controller.
  def model
    raise NotImplementedError, "#{self.class} must implement the '#{__method__}' method"
  end

  # The list of associations to eagerly load, in order to prevent N+1 queries. All associations included in the response
  # should be returned.
  #
  # @return List[Symbol] The list of associations to eagerly load.
  def include
    []
  end

  # The blueprint view to use in order to render the model objects. This method returns nil by default it order to
  # utilize the default view.
  #
  # @return [Symbol, nil] The blueprint view to use in order to render the model objects.
  def view; end

  # The base query used to fetch the objects for the controller.
  #
  # @return The base query used to fetch the objects for the controller.
  def base_query
    return model if include.empty?

    model.includes(*include)
  end

  # The blueprint used to render this view
  def blueprint
    "#{model}Blueprint".constantize
  end

  private

  def results
    blueprint.render_as_hash(order_query(paginator.results), view:)
  end

  def total
    paginator.count
  end

  def paginator
    @paginator ||= Paginator.new(base_query, params['page'], params['per_page'])
  end

  def order_query(query)
    query.order(:id)
  end

  def record_not_found
    render json: { errors: ["#{model} with id #{params[:id]} not found"] }, status: :not_found
  end
end
