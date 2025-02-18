class RedirectsController < ApplicationController
  def show
    redirect_to redirect_url.original_url, allow_other_host: true
  end

  private

  def redirect_url
    @redirect_url ||= RedirectsRepository.new.find_redirect_parsed_url_with_cache(slug: params[:slug])
  end
end
