# frozen_string_literal: true

# The title principals controller
class TitlePrincipalsController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is {TitlePrincipal}.
  #
  # @return ApplicationRecord The model for the controller. This controller returns {TitlePrincipal}.
  def model
    TitlePrincipal
  end

  # The base query used to fetch the objects for the controller. For this controller, it only fetches {TitlePrincipal}
  # objects that their title_id attribute matches the title_id parameter.
  #
  # @return The base query used to fetch the objects for the controller.
  def base_query
    super.where(title_id: params.require(:title_id)).order(:ordering)
  end

  # The list of associations to eagerly load, in order to prevent N+1 queries. This method returns [:title].
  #
  # @return List[Symbol] Returns [:title].
  def include
    [:person]
  end
end
