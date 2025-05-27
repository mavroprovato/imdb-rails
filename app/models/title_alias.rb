# frozen_string_literal: true

# The title alias join table
class TitleAlias < ApplicationRecord
  belongs_to :title
  belongs_to :region
  belongs_to :language

  validates :ordering, presence: true, uniqueness: { scope: :title_id }
  validates :alias, presence: true
end
