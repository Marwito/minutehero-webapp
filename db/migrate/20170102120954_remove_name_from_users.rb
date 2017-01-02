class RemoveNameFromUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.all.each do |u|
      u.update_attributes first_name: u.name || 'Default',
                          last_name: u.name || 'Default'
    end
    remove_column :users, :name
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
  end
end
