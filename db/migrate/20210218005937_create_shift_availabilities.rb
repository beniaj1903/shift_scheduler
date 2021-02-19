class CreateShiftAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_availabilities do |t|
      t.timestamps
    end
  end
end
