require 'rails_helper'

RSpec.describe Person, type: :model do
  subject(:person) { create(:person) }

  it { is_expected.to validate_presence_of(:unique_id) }
  it { is_expected.to validate_uniqueness_of(:unique_id) }
  it { is_expected.to validate_presence_of(:name) }
end
