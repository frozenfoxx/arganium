class AddParTime < ActiveRecord::Migration[5.0]
  def change
    add_column :levels, :par, :integer, default: 0
  end
end
