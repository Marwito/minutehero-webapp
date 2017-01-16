class AddBlockedAndSuspendedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :blocked, :boolean, default: false
    add_column :users, :suspended, :boolean, default: false
  end
end
