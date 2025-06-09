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
end
