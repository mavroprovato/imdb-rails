# frozen_string_literal: true

class Etl
  def perform
    GenreLoader.new.load_data
    TitleLoader.new.load_data
  end
end
