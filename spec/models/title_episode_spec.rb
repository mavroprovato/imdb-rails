# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleEpisode do
  subject(:title_episode) { create(:title_episode) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:parent_title).class_name('Title') }
end
