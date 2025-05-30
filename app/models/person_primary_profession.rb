# frozen_string_literal: true

# The person primary profession model
class PersonPrimaryProfession < ApplicationRecord
  belongs_to :person
  belongs_to :profession

  validates :person_id, uniqueness: { scope: :profession_id }
end
