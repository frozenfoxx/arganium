class AddSolvedLocked < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :locked, :boolean, default: true
    add_column :challenges, :solved, :boolean, default: false
  end
end
