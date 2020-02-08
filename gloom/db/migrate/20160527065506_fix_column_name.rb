class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :challenges, :type, :category
  end
end
