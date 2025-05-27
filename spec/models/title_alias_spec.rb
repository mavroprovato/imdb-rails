# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleAlias do
  subject(:title_alias) { create(:title_alias) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:region) }
  it { is_expected.to belong_to(:language) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ordering) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:title_id) }
  it { is_expected.to validate_uniqueness_of(:ordering).scoped_to(:title_id) }
  it { is_expected.to allow_values(true, false).for(:original_title) }
end
