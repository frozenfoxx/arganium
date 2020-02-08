class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :areas
      t.text :hacklifts

      t.timestamps
    end
  end
end
