class CreateChallenges < ActiveRecord::Migration[5.0]
  def change
    create_table :challenges do |t|
      t.string :name
      t.integer :area
      t.text :flag
      t.integer :difficulty
      t.string :type
      t.text :hint

      t.timestamps
    end
  end
end
