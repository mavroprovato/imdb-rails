# frozen_string_literal: true

class TitleGenre < ApplicationRecord
  self.primary_key = [ :title_id, :genre_id ]

  belongs_to :title
  belongs_to :genre

  validates :title_id, presence: true
  validates :genre_id, presence: true
  validates :title_id, uniqueness: { scope: :genre_id }
end
