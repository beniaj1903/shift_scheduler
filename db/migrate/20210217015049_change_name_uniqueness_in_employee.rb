class ChangeNameUniquenessInEmployee < ActiveRecord::Migration[6.1]
  def change
    add_index :employees, :name, unique: true
  end
end
