require 'rails_helper'

RSpec.describe RedirectUrls::IncrementVisits do
  describe "#call" do
    subject { described_class.new(id).call }
    context "when the redirect_url exists" do
      let(:redirect_url) { create(:redirect_url) }
      let(:id) { redirect_url.id }


      it "increments the visits count by 1" do
        expect { subject }.to change { redirect_url.reload.visits }.by(1)
      end
    end

    context "when the redirect_url does not exist" do
      let(:id) { 1 }
      it "raises ActiveRecord::RecordNotFound" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
