
class RedirectUrl < ApplicationRecord
  validates :original_url, presence: true, url: true
  validates :slug, uniqueness: { allow_nil: true }, length: { maximum: 13 }
  validate  :expires_at_in_future

  CachedRedirectUrl = Struct.new(:id, :original_url, :slug, :expires_at)

  private

  def expires_at_in_future
    if expires_at.present? && expires_at <= Time.current
      errors.add(:expires_at, "must be in the future")
    end
  end
end
