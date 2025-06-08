# frozen_string_literal: true

# The title episode model
class TitleEpisode < ApplicationRecord
  belongs_to :title
  belongs_to :parent_title, class_name: 'Title'
end
