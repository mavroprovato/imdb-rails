# frozen_string_literal: true

# The genres controller
class LanguagesController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Language+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Language+.
  def model
    Language
  end
end
