# frozen_string_literal: true

# Language for a title
class Language < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
