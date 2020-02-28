class Api::WebPagesController < ApplicationController
  def index
    root = WebPage.find_or_initialize_by web_page_params

    if root.persisted? || root.save
      depth = (params[:depth] || 1).to_i
      cache_expiry = (params[:cache] || 1).to_i.seconds.ago
      page = (params[:page] || 0).to_i

      # subtract 1 because crawl includes root
      @hits = root.crawl(depth, cache_expiry).uniq.length - 1

      # run query again to ensure consistent ordering of results
      @web_pages = root.descendents(depth, cache_expiry, 20, page * 20)
    else
      render_unprocessable_entity! root
    end
  end

  private

    def web_page_params
      params.require(:web_page).permit(:uri)
    end
end
