class Api::UniformResourceIdentifiersController < ApplicationController
  def index
    uri = params[:uri]
    @uniform_resource_identifiers = WebPage.where('uri LIKE ?', "%#{ uri }%").limit(10);
  end
end
