class CreateGameRecords < ActiveRecord::Migration
  def change
    create_table :game_records do |t|
      t.string :seed
      t.timestamps
    end
  end
end
