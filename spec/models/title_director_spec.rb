# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleDirector do
  subject(:title_director) { create(:title_director) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:person) }
  it { is_expected.to validate_uniqueness_of(:title_id).scoped_to(:person_id) }
end
