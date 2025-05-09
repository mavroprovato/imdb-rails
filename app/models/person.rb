# frozen_string_literal: true

class Person < ApplicationRecord
  validates :unique_id, presence: true, uniqueness: true
  validates :name, presence: true
end
