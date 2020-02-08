class ChangeHackliftsToHashes < ActiveRecord::Migration[5.0]
  def change
    add_column :hacklifts, :direction, :string, default: 'both'
  end
end
