# frozen_string_literal: true

# The person model
class Person < ApplicationRecord
  has_many :person_known_for_titles, dependent: :destroy
  has_many :known_for, through: :person_known_for_titles, source: :title

  validates :unique_id, presence: true, uniqueness: true
  validates :name, presence: true
end
