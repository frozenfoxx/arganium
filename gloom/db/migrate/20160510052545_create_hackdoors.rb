class CreateHackdoors < ActiveRecord::Migration[5.0]
  def change
    remove_column :levels, :areas, :integer

    create_table :hackdoors do |t|
      t.string :sector
    end
  end
end
