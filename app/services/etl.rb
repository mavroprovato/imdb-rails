# frozen_string_literal: true

# Performs the ETL procedure
class Etl
  def perform
    Loaders::GenreLoader.new.load_data
    Loaders::TitleLoader.new.load_data
    Loaders::PeopleLoader.new.load_data
  end
end
