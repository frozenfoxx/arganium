class RemoveHackliftsFromLevels < ActiveRecord::Migration[5.0]
  def change
    remove_column :levels, :hacklifts, :text
  end
end
