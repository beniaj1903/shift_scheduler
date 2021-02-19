class CreateShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :shifts do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :day
      t.timestamps
    end
  end
end
