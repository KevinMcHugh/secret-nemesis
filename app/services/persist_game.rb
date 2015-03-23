class PersistGame
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def execute
    gr = GameRecord.create(seed: game.seed)
    game.players.each do |player|
      PlayerRecord.create_from(player, gr)
    end
    # game.events.each do |event|
    #   EventRecord.create_from(event, gr)
    # end
  end

end