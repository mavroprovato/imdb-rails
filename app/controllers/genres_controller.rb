# frozen_string_literal: true

# The genres controller
class GenresController < BaseCrudController
  protected

  def model
    Genre
  end
end
