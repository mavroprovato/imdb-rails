# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleGenre do
  subject(:title_genre) { create(:title_genre) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:genre) }
  it { is_expected.to validate_uniqueness_of(:title_id).scoped_to(:genre_id) }
end
