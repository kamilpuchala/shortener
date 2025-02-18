class AddToRedirectUrlsExpiresAt < ActiveRecord::Migration[8.0]
  def change
    add_column :redirect_urls, :expires_at, :datetime
  end
end
