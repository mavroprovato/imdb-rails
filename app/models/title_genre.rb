# frozen_string_literal: true

class TitleGenre < ApplicationRecord
  belongs_to :title
  belongs_to :genre

  validates :title_id, presence: true
  validates :genre_id, presence: true
end
