class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_enum :application_status, [ "pending", "shortlisted", "accepted", "rejected", "withdrawn" ]

    create_table :applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.text :message, null: false
      t.date :move_in_date, null: false
      t.integer :intended_stay_months, limit: 2, null: false
      t.enum :status, enum_type: :application_status, default: "pending", null: false

      t.timestamps

      t.index [ :user_id, :listing_id ], unique: true
    end
  end
end
