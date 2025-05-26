# frozen_string_literal: true

module Etl
  module Loaders
    # Loads regions to the database
    class RegionLoader < BaseLoader
      def initialize
        super
        @data = Set.new
      end

      def load_data(batch_size = 100_000)
        super
        Region.import @data.to_a, validate: false, on_duplicate_key_ignore: true
      end

      protected

      def filename
        'title.akas.tsv.gz'
      end

      def process_data(batch)
        @data |= batch.each_with_object(Set.new) do |row, set|
          next if row[3].chomp == '\N'

          set << { code: row[3].chomp }
        end
      end
    end
  end
end
