class ChangeUniquenessInShift < ActiveRecord::Migration[6.1]
  def change
    add_index :shifts, [:employee_id, :week_id, :start_time, :day], :unique => true
    add_index :shifts, [:service_id, :week_id, :start_time, :day], :unique => true
  end
end
