# frozen_string_literal: true

# Base controller for CRUD API endpoints
class BaseCrudController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: { total: base_query.count, results: blueprint.render_as_hash(results_query, view:) }
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

  # The ordering fields available for the controller.
  #
  # @return List[Symbol] The ordering fields available for the controller.
  def ordering_fields; end

  # The default ordering field
  #
  # @return [List[Symbol], nil] The default ordering field.
  def default_ordering_field; end

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

  def paginate_query(query)
    Paginator.new(params).paginate_query query
  end

  def order_query(query)
    Ordering.new(params, ordering_fields, default_ordering_field).order_query query
  end

  def results_query
    paginate_query order_query base_query
  end

  def record_not_found
    render json: { errors: ["#{model} with id #{params[:id]} not found"] }, status: :not_found
  end
end
