# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleWriter do
  subject(:title_writer) { create(:title_writer) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:person) }
  it { is_expected.to validate_uniqueness_of(:title_id).scoped_to(:person_id) }
end
