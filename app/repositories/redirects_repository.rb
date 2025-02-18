class RedirectsRepository
  def find_redirect_parsed_url_with_cache(slug:)
    Caches::Fetch.call(cache_key: "#{cache_key[:value]}:#{slug}", expires_in: cache_key[:expires_in]) do
      url = RedirectUrl.find_by!(slug: slug)
      RedirectUrl::CachedRedirectUrl.new(url.id, url.original_url, url.slug, url.expires_at)
    end
  end

  private

  def cache_key
    CacheKey::KEYS[:redirect]
  end
end
