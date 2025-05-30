# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonPrimaryProfession do
  subject(:person_primary_profession) { create(:person_primary_profession) }

  it { is_expected.to belong_to(:person) }
  it { is_expected.to belong_to(:profession) }
  it { is_expected.to validate_uniqueness_of(:person_id).scoped_to(:profession_id) }
end
