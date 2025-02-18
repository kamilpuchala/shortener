
class RedirectUrl < ApplicationRecord
  validates :original_url, presence: true, url: true
  validates :slug, uniqueness: { allow_nil: true }
  validates :slug, length: { is: 7 }, if: -> { slug.present? }
end
