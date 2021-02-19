class ChangeUniquenessInShift < ActiveRecord::Migration[6.1]
  def change
    add_index :shifts, %i[employee_id week_id start_time day], unique: true
    add_index :shifts, %i[service_id week_id start_time day], unique: true
  end
end
