# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguagesController do
  before do
    create_list(:language, 10)
  end

  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: Language.first&.id }
    end

    it 'returns a successful response' do
      expect(response).to have_http_status :ok
    end
  end
end
