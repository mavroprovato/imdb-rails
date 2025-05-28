# frozen_string_literal: true

# The title model
class Title < ApplicationRecord
  # Possible values of the title type enum
  TITLE_TYPE_VALUES = {
    movie: 'movie', short: 'short', tv_episode: 'tvEpisode', tv_mini_series: 'tvMiniSeries', tv_movie: 'tvMovie',
    tv_pilot: 'tvPilot', tv_series: 'tvSeries', tv_short: 'tvShort', tv_special: 'tvSpecial', video: 'video',
    video_game: 'videoGame'
  }.freeze
  enum :title_type, TITLE_TYPE_VALUES

  has_many :title_genres, dependent: :destroy
  has_many :genres, through: :title_genres

  validates :unique_id, presence: true, uniqueness: true
  validates :title_type, presence: true
  validates :title, presence: true
  validates :original_title, presence: true
end
