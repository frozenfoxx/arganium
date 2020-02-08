class CreateSecrets < ActiveRecord::Migration[5.0]
  def change
    create_table :secrets do |t|
      t.integer :total
      t.integer :found,    default: 0
      t.integer :redeemed, default: 0

      t.timestamps
    end
  end
end
