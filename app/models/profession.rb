# frozen_string_literal: true

# The profession model
class Profession < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
