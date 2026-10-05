class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_enum :property_type, [ "apartment", "house" ]

    create_table :properties do |t|
      t.references :user, null: false, foreign_key: true
      t.references :neighborhood, null: false, foreign_key: true
      t.string :address, null: false
      t.enum :property_type, enum_type: :property_type, null: false
      t.integer :bedrooms_count, limit: 2, null: false
      t.integer :bathrooms_count, limit: 2, null: false
      t.text :shared_spaces

      t.timestamps
    end
  end
end
