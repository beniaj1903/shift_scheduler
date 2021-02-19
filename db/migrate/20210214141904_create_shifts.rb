class CreateShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :shifts do |t|
      t.time :start_time
      t.time :end_time
      t.integer :day
      t.timestamps
    end
  end
end
