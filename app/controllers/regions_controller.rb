# frozen_string_literal: true

# The regions controller
class RegionsController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Region+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Region+.
  def model
    Region
  end
end
