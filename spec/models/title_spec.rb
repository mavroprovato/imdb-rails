# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Title do
  subject(:title) { create(:title) }

  it { is_expected.to validate_presence_of(:unique_id) }
  it { is_expected.to validate_uniqueness_of(:unique_id) }
  it { is_expected.to validate_presence_of(:title_type) }

  it {
    expect(title).to define_enum_for(:title_type).with_values(Title::TITLE_TYPE_VALUES).backed_by_column_of_type(:enum)
  }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:original_title) }
  it { is_expected.to allow_values(true, false).for(:adult) }
  it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }

  it { is_expected.to have_many(:title_genres) }
  it { is_expected.to have_many(:genres).through(:title_genres) }
end
