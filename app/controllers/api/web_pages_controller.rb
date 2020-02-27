class Api::WebPagesController < ApplicationController
  def index
    root = WebPage.find_or_create_by web_page_params

    if root.persisted?
      depth = (params[:depth] || 1).to_i
      cache_expiry = (params[:cache] || 1).to_i.seconds.ago

      @web_pages = root.crawl(depth, cache_expiry).uniq
    else
      render_unprocessable_entity! root
    end
  end

  private

    def web_page_params
      params.require(:web_page).permit(:uri)
    end
end
