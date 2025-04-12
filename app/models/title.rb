class Title < ApplicationRecord
  enum :type, {
    movie: "movie", short: "short", tv_episode: "tvEpisode", tv_mini_series: "tvMiniSeries", tv_movie: "tvMovie",
    tv_pilot: "tvPilot", tv_series: "tvSeries", tv_short: "tvShort", tv_special: "tvSpecial", video: "video",
    video_game: "videoGame"
  }
end
