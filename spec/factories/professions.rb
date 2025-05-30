# frozen_string_literal: true

FactoryBot.define do
  factory :profession do
    sequence(:name) { |n| "Profession #{n}" }
  end
end
