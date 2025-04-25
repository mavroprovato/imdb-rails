# frozen_string_literal: true

class Title < ApplicationRecord
  enum :title_type, {
    movie: "movie", short: "short", tv_episode: "tvEpisode", tv_mini_series: "tvMiniSeries", tv_movie: "tvMovie",
    tv_pilot: "tvPilot", tv_series: "tvSeries", tv_short: "tvShort", tv_special: "tvSpecial", video: "video",
    video_game: "videoGame"
  }
  validates :unique_id, presence: true, uniqueness: true
  validates :title_type, presence: true
  validates :title, presence: true
  validates :original_title, presence: true
  validates :runtime, presence: true
end
