class SeparateDateTimeInCalls < ActiveRecord::Migration[5.0]
  def up
    Call.all.each do |c|
      c.update_attribute :schedule_date, c.created_at.to_date
      c.update_attribute :schedule_time, c.created_at.to_time
    end
  end

  def down; end
end
