require 'rails_helper'

RSpec.describe TitleGenre, type: :model do
  subject(:title_genre) { create(:title_genre) }

  it { should belong_to(:title) }
  it { should belong_to(:genre) }
  it { should validate_uniqueness_of(:title_id).scoped_to(:genre_id) }
end
