class AddForeignsKeysToShifts < ActiveRecord::Migration[6.1]
  def change
    add_reference :shifts, :employee, foreign_key: true
    add_reference :shifts, :service, foreign_key: true
    add_reference :shifts, :week, foreign_key: true
  end
end
