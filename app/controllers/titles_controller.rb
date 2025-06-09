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

  def include
    [:genres, { title_aliases: %i[region language] }]
  end

  def view
    :full
  end
end
