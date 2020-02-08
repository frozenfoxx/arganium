class CreateGameLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :game_logs do |t|
      t.text :content

      t.timestamps
    end
  end
end
