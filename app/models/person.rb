# frozen_string_literal: true

# The person model
class Person < ApplicationRecord
  validates :unique_id, presence: true, uniqueness: true
  validates :name, presence: true
end
