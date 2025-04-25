require 'rails_helper'

RSpec.describe TitleGenre, type: :model do
  subject(:title_genre) { create(:title_genre) }

  it { is_expected.to validate_presence_of(:title_id) }
  it { is_expected.to validate_presence_of(:genre_id) }
end
