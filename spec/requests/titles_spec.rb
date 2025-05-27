# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Titles' do
  before do
    create_list(:title, 10)
  end

  describe 'GET /titles' do
    before do
      get '/titles'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
