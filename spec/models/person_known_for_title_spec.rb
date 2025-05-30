# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonKnownForTitle do
  subject(:person_known_for_title) { create(:person_known_for_title) }

  it { is_expected.to belong_to(:person) }
  it { is_expected.to belong_to(:title) }
  it { is_expected.to validate_uniqueness_of(:person_id).scoped_to(:title_id) }
end
