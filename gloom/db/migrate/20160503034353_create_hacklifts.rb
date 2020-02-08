class CreateHacklifts < ActiveRecord::Migration[5.0]
  def change
    create_table :hacklifts do |t|
      t.string :sector

      t.timestamps
    end
  end
end
