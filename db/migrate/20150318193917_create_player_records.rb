class CreatePlayerRecords < ActiveRecord::Migration
  def change
    create_table :player_records do |t|
      t.integer :game_record_id
      t.integer :order
      t.string :brain
      t.boolean :spy
    end
  end
end
