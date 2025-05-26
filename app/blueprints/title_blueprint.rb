# frozen_string_literal: true

# Blueprint for title models
class TitleBlueprint < Blueprinter::Base
  identifier :id

  fields :unique_id, :title_type, :title, :original_title, :adult, :start_year, :end_year, :runtime

  association :genres, blueprint: GenreBlueprint
end
