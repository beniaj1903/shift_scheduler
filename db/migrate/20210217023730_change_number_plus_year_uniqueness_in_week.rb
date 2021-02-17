class ChangeNumberPlusYearUniquenessInWeek < ActiveRecord::Migration[6.1]
  def change
    add_index :weeks, [:year, :number], :unique => true
  end
end
