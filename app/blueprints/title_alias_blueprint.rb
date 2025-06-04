# frozen_string_literal: true

# Blueprint for title aliases
class TitleAliasBlueprint < Blueprinter::Base
  identifier :id

  fields :ordering, :name, :alias_type, :extra_attribute, :original_title

  association :region, blueprint: RegionBlueprint
  association :language, blueprint: LanguageBlueprint
end
