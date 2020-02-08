class ChangeDifficulty < ActiveRecord::Migration[5.0]
  def change
    remove_column :challenges, :difficulty

    add_column :challenges, :points, :integer, default: 0
  end
end
