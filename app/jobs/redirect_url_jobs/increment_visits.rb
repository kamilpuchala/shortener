module RedirectUrlJobs
  class IncrementVisits < ApplicationJob
    queue_as :default

    def perform(id)
      RedirectUrls::IncrementVisits.new(id).call
    end
  end
end
