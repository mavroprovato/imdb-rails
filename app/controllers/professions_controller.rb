# frozen_string_literal: true

# The genres controller
class ProfessionsController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Profession+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Profession+.
  def model
    Profession
  end
end
