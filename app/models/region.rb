# frozen_string_literal: true

# Region for a title
class Region < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
