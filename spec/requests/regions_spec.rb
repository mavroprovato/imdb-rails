# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Regions' do
  before do
    create_list(:region, 10)
  end

  describe 'GET /regions' do
    before do
      get '/regions'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
