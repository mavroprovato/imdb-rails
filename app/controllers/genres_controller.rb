# frozen_string_literal: true

# The genres controller
class GenresController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Genre+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Genre+.
  def model
    Genre
  end

  # The ordering fields available for the controller.
  #
  # @return List[Symbol] Returns [:name].
  def ordering_fields
    [:name]
  end

  def default_ordering_field
    :name
  end
end
