# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language do
  subject(:language) { create(:language) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
