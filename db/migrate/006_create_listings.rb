class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_enum :listing_status, [ "draft", "published", "reserved", "rented", "withdrawn" ]

    create_table :listings do |t|
      t.references :property, null: false, foreign_key: true
      t.string :title, null: false
      t.decimal :monthly_rent, precision: 8, scale: 2, null: false
      t.decimal :deposit, precision: 8, scale: 2, null: false
      t.date :available_date, null: false
      t.integer :minimum_stay_months, limit: 2, null: false
      t.boolean :is_furnished, default: false, null: false
      t.boolean :has_private_bathroom, default: false, null: false
      t.enum :status, enum_type: :listing_status, default: "draft", null: false

      t.timestamps
    end
  end
end
