class CreateSavedListings < ActiveRecord::Migration[8.1]
  def change
    create_table :saved_listings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps

      t.index [ :user_id, :listing_id ], unique: true
    end
  end
end
