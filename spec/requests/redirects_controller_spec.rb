require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe "GET #show" do
    let(:redirect_url) { create(:redirect_url) }
    let(:subject) { get :show, params: { slug: redirect_url.slug } }

    context 'when redirect_url exists' do
      it "redirects to the original_url" do
        subject

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(redirect_url.original_url)
      end

      it "enqueues an IncrementVisits job" do
        expect {
          subject
        }.to have_enqueued_job(RedirectUrlJobs::IncrementVisits).with(redirect_url.id)
      end
    end

    context "when repository raises ActiveRecord::RecordNotFound" do
      it "raises ActiveRecord::RecordNotFound" do
        get :show, params: { slug: "non-existent" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
