class ChangeDefaultsInWeek < ActiveRecord::Migration[6.1]
  def change
    change_column :weeks, :year, :integer, default: Date.today.strftime('%y').to_i
    change_column :weeks, :number, :integer, default: Date.today.strftime('%W').to_i
  end
end
