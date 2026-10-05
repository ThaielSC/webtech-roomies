
class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :pasword_digest, null: false
      t.string :firts_name, null: false
      t.string :last_name, null: false
      t.string :phone_number
      t.boolean :is_moderator, null: false

      t.timestamps

      t.index :email_address, unique: true
    end
  end
end
