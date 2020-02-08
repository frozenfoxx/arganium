class AddFileToLevels < ActiveRecord::Migration[5.0]
  def change
    add_column :levels, :file, :string
  end
end
