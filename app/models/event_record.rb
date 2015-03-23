class EventRecord < ActiveRecord::Base
  belongs_to :game_record

  def self.create_from(event, game_record, index)
    create(event_type: event.class.to_s, event_json: event.to_json.to_s,
      game_record: game_record, order: index)
  end
end