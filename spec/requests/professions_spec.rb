# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Professions' do
  before do
    create_list(:profession, 10)
  end

  describe 'GET /professions' do
    before do
      get '/professions'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
