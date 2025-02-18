require 'rails_helper'

class DummyUrlModel
  include ActiveModel::Validations
  attr_accessor :url

  validates :url, url: true
end

RSpec.describe UrlValidator, type: :model do
  subject { DummyUrlModel.new }

  context "when given a valid HTTPS URL" do
    it "is valid" do
      subject.url = "https://example.com"
      subject.valid?
      expect(subject.errors[:url]).to be_empty
    end
  end

  context "when given an HTTP URL" do
    it "is invalid" do
      subject.url = "http://example.com"
      subject.valid?
      expect(subject.errors[:url]).to include("must be a valid https URL with a given host (for example, 'https://example.com')")
    end
  end

  context "when given an invalid URL string" do
    it "is invalid" do
      subject.url = "not-a-url"
      subject.valid?
      expect(subject.errors[:url]).to include("must be a valid https URL with a given host (for example, 'https://example.com')")
    end
  end

  context "when given a URL with an empty host" do
    it "is invalid" do
      subject.url = "https://"
      subject.valid?
      expect(subject.errors[:url]).to include("must be a valid https URL with a given host (for example, 'https://example.com')")
    end
  end
end
