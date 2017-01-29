class AddDateAndTimeToCalls < ActiveRecord::Migration[5.0]
  def change
    add_column :calls, :schedule_date, :date
    add_column :calls, :schedule_time, :time
  end
end
