# frozen_string_literal: true

FactoryBot.define do
  factory :title_episode do
    title
    parent_title { create(:title) }
    season { 1 }
    episode { 1 }
  end
end
