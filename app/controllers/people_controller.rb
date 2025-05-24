# frozen_string_literal: true

# The people controller
class PeopleController < BaseCrudController
  protected

  def model
    Person
  end
end
