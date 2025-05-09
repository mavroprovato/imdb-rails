# frozen_string_literal: true

class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
