# frozen_string_literal: true

# The people controller
class PeopleController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Person+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Person+.
  def model
    Person
  end

  def include
    %i[known_for primary_professions]
  end
end
