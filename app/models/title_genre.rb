class TitleGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :title
end
