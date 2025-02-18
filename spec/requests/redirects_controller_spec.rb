require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe "GET #show" do
    let(:redirect_url) { create(:redirect_url, expires_at: expires_at) }
    let(:subject) { get :show, params: { slug: redirect_url.slug } }

    context 'when redirect_url exists and expires_at is nil' do
      let(:expires_at) { nil }
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

    context 'when redirect_url exists and expires_at is in the future' do
      let(:expires_at) { 1.day.from_now }
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

    context 'when redirect_url exists and expires_at is in the past' do
      let(:expires_at) { 1.day.ago }
      let(:redirect_url) do
        redirect = build(:redirect_url, expires_at: expires_at)
        redirect.save(validate: false)
        redirect
      end
      it "renders a 404" do
        subject

        expect(response).to have_http_status(:not_found)
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
