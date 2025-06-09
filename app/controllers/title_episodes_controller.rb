# frozen_string_literal: true

# The title episodes controller
class TitleEpisodesController < BaseCrudController
  protected

  def model
    TitleEpisode
  end

  def base_query
    super.where(parent_title_id: params[:title_id]).order(:season, :episode)
  end
end
