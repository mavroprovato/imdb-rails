# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People' do
  before do
    create_list(:person, 10)
  end

  describe 'GET /people' do
    before do
      get '/people'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
