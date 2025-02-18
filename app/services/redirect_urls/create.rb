module RedirectUrls
  class Create
    attr_reader :original_url
    def initialize(original_url:)
      @original_url = original_url
    end

    def call
      redirect_url = initialize_redirect_url

      ActiveRecord::Base.transaction do
        redirect_url = save_redirect_url(redirect_url)
        redirect_url = update_redirect_url_slug(redirect_url)
      end

      redirect_url
    end

    private

    def initialize_redirect_url
      RedirectUrl.new(original_url: original_url)
    end

    def save_redirect_url(redirect_url)
      return redirect_url if redirect_url.save

      raise ActiveRecord::Rollback
    end

    def update_redirect_url_slug(redirect_url)
      redirect_url.slug = generate_slug(redirect_url.id)
      return redirect_url if redirect_url.save

      raise ActiveRecord::Rollback
    end
    def generate_slug(id)
      RedirectUrls::GenerateSlug.new(id).call
    end
  end
end
