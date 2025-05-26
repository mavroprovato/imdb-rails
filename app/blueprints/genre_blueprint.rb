# frozen_string_literal: true

# Blueprint for genre models
class GenreBlueprint < Blueprinter::Base
  identifier :id

  fields :name
end
