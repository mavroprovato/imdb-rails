# frozen_string_literal: true

FactoryBot.define do
  factory :title do
    sequence(:unique_id) { |n| "tt#{n}" }
    title_type { 'movie' }
    title { 'Title' }
    original_title { 'Original Title' }
    adult { false }
    start_year { 1980 }
    end_year { 1990 }
    runtime { 120 }
  end
end
