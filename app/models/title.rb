# frozen_string_literal: true

# The title model
class Title < ApplicationRecord
  # Possible values of the title type field
  TITLE_TYPE_VALUES = {
    movie: 'movie', short: 'short', tv_episode: 'tvEpisode', tv_mini_series: 'tvMiniSeries', tv_movie: 'tvMovie',
    tv_pilot: 'tvPilot', tv_series: 'tvSeries', tv_short: 'tvShort', tv_special: 'tvSpecial', video: 'video',
    video_game: 'videoGame'
  }.freeze
  enum :title_type, TITLE_TYPE_VALUES

  has_many :title_genres, dependent: :destroy
  has_many :genres, through: :title_genres
  has_many :title_aliases, dependent: :destroy
  has_many :title_directors, dependent: :destroy
  has_many :directors, through: :title_directors, source: :person
  has_many :title_writers, dependent: :destroy
  has_many :writers, through: :title_writers, source: :person

  validates :unique_id, presence: true, uniqueness: true
  validates :title_type, presence: true
  validates :title, presence: true
  validates :original_title, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
end
