require 'rails_helper'

RSpec.describe Person, type: :model do
  subject(:person) { create(:person) }

  it { should validate_presence_of(:unique_id) }
  it { should validate_uniqueness_of(:unique_id) }
  it { should validate_presence_of(:name) }
end
