class CreateShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :shifts do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
