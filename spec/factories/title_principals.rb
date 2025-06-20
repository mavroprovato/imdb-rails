FactoryBot.define do
  factory :title_principal do
    title { nil }
    person { nil }
    ordering { 1 }
    job { "MyString" }
    category { "MyString" }
    characters { "MyString" }
  end
end
