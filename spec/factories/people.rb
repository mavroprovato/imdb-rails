# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    unique_id { "MyString" }
    name { "MyString" }
    birth_year { 1 }
    death_year { 1 }
  end
end
