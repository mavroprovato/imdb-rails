# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitlePrincipal do
  subject(:title_principal) { create(:title_principal) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:person) }
  it { is_expected.to validate_uniqueness_of(:person_id).scoped_to(:title_id, :ordering) }
end
