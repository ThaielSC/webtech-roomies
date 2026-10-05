class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      # Relación 1 a 1 estricta: índice único en visit_id para evitar más de una reseña por visita
      t.references :visit, null: false, foreign_key: true, index: { unique: true }
      t.references :property, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, limit: 2, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end
