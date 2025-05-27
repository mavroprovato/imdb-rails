# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    sequence(:unique_id) { |n| "nm#{n}" }
    name { 'John Doe' }
    birth_year { 1950 }
    death_year { 2010 }
  end
end
