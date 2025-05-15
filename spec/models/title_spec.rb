require 'rails_helper'

RSpec.describe Title do
  subject(:title) { create(:title) }

  let(:title_type_enum_values) do
    {
      movie: "movie", short: "short", tv_episode: "tvEpisode", tv_mini_series: "tvMiniSeries", tv_movie: "tvMovie",
      tv_pilot: "tvPilot", tv_series: "tvSeries", tv_short: "tvShort", tv_special: "tvSpecial", video: "video",
      video_game: "videoGame"
    }
  end

  it { is_expected.to validate_presence_of(:unique_id) }
  it { is_expected.to validate_uniqueness_of(:unique_id) }
  it { is_expected.to validate_presence_of(:title_type) }

  it {
    expect(title).to define_enum_for(:title_type).with_values(title_type_enum_values).backed_by_column_of_type(:enum)
  }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:original_title) }
  it { is_expected.to validate_presence_of(:runtime) }
  it { is_expected.to have_many(:title_genres) }
  it { is_expected.to have_many(:genres).through(:title_genres) }
end
