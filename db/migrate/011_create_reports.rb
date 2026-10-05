class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_enum :report_status, [ "pending", "reviewed", "dismissed", "action_taken" ]

    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.string :reason_category, null: false
      t.text :details, null: false
      t.enum :status, enum_type: :report_status, default: "pending", null: false

      t.timestamps
    end
  end
end
