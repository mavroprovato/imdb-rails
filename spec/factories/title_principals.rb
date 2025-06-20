# frozen_string_literal: true

FactoryBot.define do
  factory :title_principal do
    title
    person
    ordering { 1 }
    principal_category { 'actor' }
    job { 'job' }
    characters { 'characters' }
  end
end
