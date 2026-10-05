class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    create_enum :visit_status, [ "proposed", "confirmed", "completed", "cancelled" ]

    create_table :visits do |t|
      t.references :application, null: false, foreign_key: true
      t.datetime :date_time, null: false
      t.enum :status, enum_type: :visit_status, default: "proposed", null: false
      t.text :notes

      t.timestamps
    end
  end
end
