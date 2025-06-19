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

  # The list of associations to eagerly load, in order to prevent N+1 queries. This method returns
  # %i[known_for primary_professions].
  #
  # @return List[Symbol] Returns %i[known_for primary_professions].
  def include
    %i[known_for primary_professions]
  end

  # The blueprint view to use in order to render the model objects. This method returns :full in order to include the
  # associations of the +Person+ model.
  #
  # @return [Symbol, nil] Return :full.
  def view
    :full
  end
end
