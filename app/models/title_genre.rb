# frozen_string_literal: true

# The title genre join model
class TitleGenre < ApplicationRecord
  belongs_to :title
  belongs_to :genre

  validates :title_id, uniqueness: { scope: :genre_id }
end
