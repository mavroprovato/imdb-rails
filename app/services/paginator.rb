# frozen_string_literal: true

# A class for paginating queries
class Paginator
  # The default page size
  DEFAULT_PAGE_SIZE = 100
  # The maximum page size
  MAX_PAGE_SIZE = 1000

  def initialize(page = 1, per_page = DEFAULT_PAGE_SIZE)
    @page = parse_page(page)
    @per_page = parse_per_page(per_page)
  end

  def paginate_query(query)
    query.limit(per_page).offset(offset)
  end

  private

  attr_reader :page, :per_page

  def parse_page(page)
    page = page.to_i
    return 1 if page < 1

    page
  end

  def parse_per_page(per_page)
    per_page = per_page.to_i
    return DEFAULT_PAGE_SIZE if per_page <= 0

    [MAX_PAGE_SIZE, per_page].min
  end

  def offset
    (page - 1) * per_page
  end
end
