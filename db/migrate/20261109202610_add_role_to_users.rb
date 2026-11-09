class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :role, :integer, default: 0, null: false

    execute <<~SQL
      UPDATE users
      SET role = 1
      WHERE is_moderator = TRUE
    SQL
  end

  def down
    remove_column :users, :role
  end
end