# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    sequence(:code) { |n| "code#{n}" }
    sequence(:name) { |n| "Name #{n}" }
  end
end
