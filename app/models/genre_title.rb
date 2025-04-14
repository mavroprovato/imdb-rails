class GenreTitle < ApplicationRecord
  belongs_to :genre
  belongs_to :title
end
