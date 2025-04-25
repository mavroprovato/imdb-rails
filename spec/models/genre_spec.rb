# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  subject(:genre) { create(:genre) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
