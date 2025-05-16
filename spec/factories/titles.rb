# frozen_string_literal: true

FactoryBot.define do
  factory :title do
    unique_id { 'unique_id' }
    title_type { 'movie' }
    title { 'Title' }
    original_title { 'Original Title' }
    adult { false }
    start_year { Date.current.year }
    end_year { Date.current.year }
    runtime { 120 }
  end
end
