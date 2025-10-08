# frozen_string_literal: true

# A class for paginating queries
class Paginator
  # The page parameter name
  PAGE_PARAM = 'page'
  # The page site parameter name
  PAGE_SIZE_PARAM = 'per_page'
  # The default page size
  DEFAULT_PAGE_SIZE = 100
  # The maximum page size
  MAX_PAGE_SIZE = 1000

  # Initialize the paginator.
  #
  # @param params [ActionController::Params] The request parameters.
  def initialize(params)
    @page = parse_page(params)
    @per_page = parse_per_page(params)
  end

  # Paginate the query.
  #
  # @param query ActiveRecord::Relation The query.
  # @return ActiveRecord::Relation The paginated query.
  def paginate_query(query)
    query.limit(per_page).offset(offset)
  end

  private

  attr_reader :page, :per_page

  def parse_page(params)
    page = params[PAGE_PARAM].to_i
    return 1 if page < 1

    page
  end

  def parse_per_page(params)
    per_page = params[PAGE_SIZE_PARAM].to_i
    return DEFAULT_PAGE_SIZE if per_page <= 0

    [MAX_PAGE_SIZE, per_page].min
  end

  def offset
    (page - 1) * per_page
  end
end
