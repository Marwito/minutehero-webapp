class AddTimeZoneToCalls < ActiveRecord::Migration[5.0]
  def change
    add_column :calls, :time_zone, :string
  end
end
