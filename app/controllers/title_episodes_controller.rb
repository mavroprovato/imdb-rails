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

  def base_query
    super.where(parent_title_id: params[:title_id]).order(:season, :episode)
  end
end
