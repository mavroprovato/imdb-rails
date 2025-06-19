# frozen_string_literal: true

# Blueprint for people models
class PersonBlueprint < Blueprinter::Base
  identifier :id

  fields :unique_id, :name, :birth_year, :death_year

  view :full do
    association :known_for, blueprint: TitleBlueprint
    association :primary_professions, blueprint: ProfessionBlueprint
  end
end
