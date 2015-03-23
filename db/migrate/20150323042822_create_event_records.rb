class CreateEventRecords < ActiveRecord::Migration
  def change
    create_table :event_records do |t|
      t.integer :game_record_id
      t.string :event_type
      t.text :event_json
      t.integer :order
    end
  end
end
