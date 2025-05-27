# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Languages' do
  before do
    create_list(:language, 10)
  end

  describe 'GET /languages' do
    before do
      get '/languages'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
