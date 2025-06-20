# frozen_string_literal: true

# The title principal model
class TitlePrincipal < ApplicationRecord
  # Possible values of the category field
  CATEGORY_VALUES = {
    actor: 'actor', actress: 'actress', archive_footage: 'archive_footage', archive_sound: 'archive_sound',
    casting_director: 'casting_director', cinematographer: 'cinematographer', composer: 'composer',
    director: 'director', editor: 'editor', producer: 'producer', production_designer: 'production_designer',
    self: 'self', writer: 'writer'
  }.freeze
  enum :principal_category, CATEGORY_VALUES

  belongs_to :title
  belongs_to :person

  validates :person_id, uniqueness: { scope: %i[title_id ordering] }
end
