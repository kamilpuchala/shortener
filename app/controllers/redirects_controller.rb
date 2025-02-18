class RedirectsController < ApplicationController
  def show
    if expired?(redirect_url)
      return render html: html_file.html_safe, status: :not_found
    end

    increment_visits
    redirect_to redirect_url.original_url, allow_other_host: true
  end

  private

  def redirect_url
    @redirect_url ||= RedirectsRepository.new.find_redirect_parsed_url_with_cache(slug: params[:slug])
  end
  
  def expired?(redirect_url)
    redirect_url.expires_at.present? && redirect_url.expires_at < Time.current
  end

  def increment_visits
    RedirectUrlJobs::IncrementVisits.perform_later(redirect_url.id)
  end

  def html_file
    File.read(Rails.root.join("public", "404.html"))
  end
end
