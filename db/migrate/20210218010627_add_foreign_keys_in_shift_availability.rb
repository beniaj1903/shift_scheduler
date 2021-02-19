class AddForeignKeysInShiftAvailability < ActiveRecord::Migration[6.1]
  def change
    add_reference :shift_availabilities, :employee, foreign_key: true
    add_reference :shift_availabilities, :shift, foreign_key: true
  end
end
