require 'rails_helper'

RSpec.describe Title, type: :model do
  subject(:title) { create(:title) }

  it { should validate_presence_of(:unique_id) }
  it { should validate_uniqueness_of(:unique_id) }
  it { should validate_presence_of(:title_type) }
  it {
    should define_enum_for(:title_type).with_values({
      movie: "movie", short: "short", tv_episode: "tvEpisode", tv_mini_series: "tvMiniSeries", tv_movie: "tvMovie",
      tv_pilot: "tvPilot", tv_series: "tvSeries", tv_short: "tvShort", tv_special: "tvSpecial", video: "video",
      video_game: "videoGame"
    }).backed_by_column_of_type(:enum)
  }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:original_title) }
  it { should validate_presence_of(:runtime) }
end
