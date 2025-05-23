# frozen_string_literal: true

# The genre controller
class GenresController < ApplicationController
  def index
    render json: Genre.all
  end
end
