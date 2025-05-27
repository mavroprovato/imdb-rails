# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    sequence(:code) { |n| "CODE#{n}" }
  end
end
