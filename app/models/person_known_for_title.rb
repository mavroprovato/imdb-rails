# frozen_string_literal: true

# The person know for titles model
class PersonKnownForTitle < ApplicationRecord
  belongs_to :person
  belongs_to :title

  validates :person_id, uniqueness: { scope: :title_id }
end
