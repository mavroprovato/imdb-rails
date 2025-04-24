# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  subject(:genre) { create(:genre) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
