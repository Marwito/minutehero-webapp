class SeparateDateTimeInCalls < ActiveRecord::Migration[5.0]
  def up
    Call.all.each do |c|
      if c.date_time
        c.update_attribute :schedule_date, c.date_time.to_date
        c.update_attribute :schedule_time, c.date_time.to_time
      end
    end
  end

  def down; end
end
