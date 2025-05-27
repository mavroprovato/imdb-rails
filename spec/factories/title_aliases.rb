# frozen_string_literal: true

FactoryBot.define do
  factory :title_alias do
    ordering { 1 }
    title { 'MyString' }
    region
    language
    originalTitle { true }
  end
end
