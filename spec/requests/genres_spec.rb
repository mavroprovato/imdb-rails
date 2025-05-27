# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Genres' do
  before do
    create_list(:genre, 10)
  end

  describe 'GET /genres' do
    before do
      get '/genres'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
