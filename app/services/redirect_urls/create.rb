module RedirectUrls
  class Create
    attr_reader :original_url, :expires_at, :custom_slug
    def initialize(original_url:, expires_at: nil, custom_slug: nil)
      @original_url = original_url
      @expires_at = expires_at
      @custom_slug = custom_slug
    end

    def call
      redirect_url = initialize_redirect_url

      ActiveRecord::Base.transaction do
        redirect_url = save_redirect_url(redirect_url)
        redirect_url = update_redirect_url_slug(redirect_url)
      end

      write_to_cache(redirect_url)
      redirect_url
    end

    private

    def initialize_redirect_url
      RedirectUrl.new(original_url: original_url, expires_at: expires_at)
    end

    def save_redirect_url(redirect_url)
      return redirect_url if redirect_url.save

      raise ActiveRecord::Rollback
    end

    def update_redirect_url_slug(redirect_url)
      redirect_url.slug =  custom_slug.present? ? set_custom_slug(redirect_url) : generate_slug(redirect_url.id)

      return redirect_url if redirect_url.save
      raise ActiveRecord::Rollback
    end

    def set_custom_slug(redirect_url)
      if custom_slug.length == 7
        redirect_url.errors.add(
          :slug,
          "cannot be a 7-character slug because this length is only available for auto generated slugs "
        )
        raise ActiveRecord::Rollback
      end

      redirect_url.slug = custom_slug
    end
    def generate_slug(id)
      RedirectUrls::GenerateSlug.new(id).call
    end

    def write_to_cache(redirect_url)
      Caches::Write.call(cache_key: "#{cache_key[:value]}:#{redirect_url.slug}",
                         value: cached_value(redirect_url),
                         expires_in: cache_key[:expires_in])
    end

    def cache_key
      CacheKey::KEYS[:redirect]
    end

    def cached_value(redirect_url)
      RedirectUrl::CachedRedirectUrl.new(redirect_url.id, redirect_url.original_url, redirect_url.slug)
    end
  end
end
