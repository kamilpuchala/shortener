require 'rails_helper'

RSpec.describe RedirectUrlJobs::IncrementVisits, type: :job do
  let(:redirect_url) { create(:redirect_url, visits: 0) }

  describe '.perform_later' do
    it 'enqueues a job with the correct arguments' do
      expect {
        described_class.perform_later(redirect_url.id)
      }.to have_enqueued_job(described_class)
             .with(redirect_url.id)
             .on_queue('default')
    end
  end

  describe '#perform' do
    it 'increments visits on the RedirectUrl record (if that is what the service does)' do
      described_class.new.perform(redirect_url.id)

      expect(redirect_url.reload.visits).to eq(1)
    end
  end
end
