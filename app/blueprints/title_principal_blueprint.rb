# frozen_string_literal: true

# Blueprint for title principal models
class TitlePrincipalBlueprint < Blueprinter::Base
  identifier :id

  fields :ordering, :principal_category, :job, :characters
  association :person, blueprint: PersonBlueprint
end
