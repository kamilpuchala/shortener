module RedirectUrls
  class IncrementVisits
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def call
      redirect_url.increment!(:visits)
    end


    private

    def redirect_url
      RedirectUrl.find(id)
    end
  end
end
