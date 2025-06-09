# frozen_string_literal: true

# The titles controller
class TitlesController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +Title+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +Title+.
  def model
    Title
  end

  # The list of associations to eagerly load, in order to prevent N+1 queries. This method returns
  # [:genres, { title_aliases: %i[region language] }].
  #
  # @return List[Symbol] Returns [:genres, { title_aliases: %i[region language] }].
  def include
    [:genres, { title_aliases: %i[region language] }]
  end

  def view
    :full
  end
end
