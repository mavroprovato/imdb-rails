require 'rails_helper'

RSpec.describe TitleGenre, type: :model do
  subject(:title_genre) { create(:title_genre) }

  it { should validate_presence_of(:title_id) }
  it { should validate_presence_of(:genre_id) }
end
