class CreateRedirectUrl < ActiveRecord::Migration[8.0]
  def change
    create_table :redirect_urls do |t|
      t.string :slug
      t.string :original_url, null: false
      t.integer :visits, default: 0, null: false

      t.timestamps
    end
    
    add_index :redirect_urls, :slug, unique: true
  end
end
