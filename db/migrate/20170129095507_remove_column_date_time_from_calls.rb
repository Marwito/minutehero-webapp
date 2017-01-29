class RemoveColumnDateTimeFromCalls < ActiveRecord::Migration[5.0]
  def change
    remove_column :calls, :date_time
  end
end
