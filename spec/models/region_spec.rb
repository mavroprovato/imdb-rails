# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Region do
  subject(:region) { create(:region) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
end
