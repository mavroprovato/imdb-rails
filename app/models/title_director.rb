# frozen_string_literal: true

# The title director join table
class TitleDirector < ApplicationRecord
  belongs_to :title
  belongs_to :person

  validates :title_id, uniqueness: { scope: :person_id }
end
