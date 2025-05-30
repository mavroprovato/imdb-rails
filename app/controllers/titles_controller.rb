# frozen_string_literal: true

# The titles controller
class TitlesController < BaseCrudController
  protected

  def model
    Title
  end

  def include
    [:genres]
  end
end
