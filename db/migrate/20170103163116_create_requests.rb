class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :from
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
