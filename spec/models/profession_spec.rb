# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profession do
  subject(:profession) { create(:profession) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
