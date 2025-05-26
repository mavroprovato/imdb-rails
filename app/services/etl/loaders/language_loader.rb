# frozen_string_literal: true

module Etl
  module Loaders
    # Loads languages to the database
    class LanguageLoader < BaseLoader
      def initialize
        super
        @data = Set.new
      end

      def load_data(batch_size = 100_000)
        super
        Language.import @data.to_a, validate: false, on_duplicate_key_ignore: true
      end

      protected

      def filename
        'title.akas.tsv.gz'
      end

      def process_data(batch)
        @data |= batch.each_with_object(Set.new) do |row, set|
          next if row[4].chomp == '\N'

          set << { code: row[4].chomp }
        end
      end
    end
  end
end
