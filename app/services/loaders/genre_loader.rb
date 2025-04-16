# frozen_string_literal: true

module Loaders
  class GenreLoader < BaseLoader
    def initialize
      @data = Set.new
    end

    def load_data(batch_size = 100_000)
      super(batch_size)

      Genre.import @data.to_a, validate: false, on_duplicate_key_ignore: true
    end

    protected

    def filename
      "title.basics.tsv.gz"
    end

    def process_data(batch)
      @data |= batch.each_with_object(Set.new) do |row, set|
        next if row[8].chomp == '\N'

        row[8].chomp.split(",").each { |name| set << { name: } }
      end
    end
  end
end
