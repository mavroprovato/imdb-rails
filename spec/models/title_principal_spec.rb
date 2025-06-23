# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitlePrincipal do
  subject(:title_principal) { create(:title_principal) }

  it { is_expected.to belong_to(:title) }
  it { is_expected.to belong_to(:person) }
  it { is_expected.to validate_uniqueness_of(:person_id).scoped_to(:title_id, :ordering) }

  it {
    expect(title_principal).to define_enum_for(:principal_category).with_values(TitlePrincipal::CATEGORY_VALUES)
                                                                   .backed_by_column_of_type(:enum)
  }
end
