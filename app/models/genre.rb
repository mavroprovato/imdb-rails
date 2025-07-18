# frozen_string_literal: true

# The genre model
class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
