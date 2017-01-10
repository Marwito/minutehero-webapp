class CreateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :calls do |t|
      t.string :title
      t.string :dial_in
      t.string :participant_code
      t.datetime :date_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
