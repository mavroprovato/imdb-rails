# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageFinder do
  describe '#language_name' do
    it 'returns the correct language for a standard ISO 639-1 language' do
      expect(described_class.language_name('en')).to eq('English')
    end

    it 'uses the overridden name if provided' do
      expect(described_class.language_name('el')).to eq('Greek')
    end

    it 'removes everything after the first semicolon from the name' do
      expect(described_class.language_name('pa')).to eq('Panjabi')
    end
  end
end
