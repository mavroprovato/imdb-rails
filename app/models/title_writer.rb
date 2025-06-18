# frozen_string_literal: true

# The title writer join table
class TitleWriter < ApplicationRecord
  belongs_to :title
  belongs_to :person

  validates :title_id, uniqueness: { scope: :person_id }
end
