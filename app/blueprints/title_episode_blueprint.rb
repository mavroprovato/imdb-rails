# frozen_string_literal: true

# Blueprint for title episode models
class TitleEpisodeBlueprint < Blueprinter::Base
  identifier :id

  fields :season, :episode
  association :title, blueprint: TitleBlueprint
end
