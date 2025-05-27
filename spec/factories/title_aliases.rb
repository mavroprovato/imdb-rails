# frozen_string_literal: true

FactoryBot.define do
  factory :title_alias do
    title
    region
    language
    name { 'Alias' }
    ordering { 1 }
    original_title { true }
  end
end
