# frozen_string_literal: true

# The title genre model
class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
