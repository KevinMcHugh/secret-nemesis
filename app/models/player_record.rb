class PlayerRecord < ActiveRecord::Base
  belongs_to :game_record

  def self.create_from(player, game_record)
    create(brain: player.brain.class.to_s, spy: player.spy?, game_record: game_record)
  end
end