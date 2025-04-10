FactoryBot.define do
  factory :title do
    unique_id { "MyString" }
    title { "MyString" }
    original_title { "MyString" }
    adult { false }
    start_year { 1 }
    end_year { 1 }
    runtime { 1 }
  end
end
