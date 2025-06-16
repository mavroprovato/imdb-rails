# frozen_string_literal: true

# The title episodes controller
class TitleEpisodesController < BaseCrudController
  protected

  # The model for the controller. The model for this controller is +TitleEpisode+.
  #
  # @return ApplicationRecord The model for the controller. This controller returns +TitleEpisode+.
  def model
    TitleEpisode
  end

  # The base query used to fetch the objects for the controller. For this controller, it only fetches +TitleEpisode+
  # objects that their parent_title_id attribute matches the title_id parameter.
  #
  # @return The base query used to fetch the objects for the controller.
  def base_query
    super.where(parent_title_id: params.require(:title_id)).order(:season, :episode)
  end

  # The list of associations to eagerly load, in order to prevent N+1 queries. This method returns [:title].
  #
  # @return List[Symbol] Returns [:title].
  def include
    [:title]
  end
end
