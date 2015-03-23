class PersistGame
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def execute
    gr = GameRecord.create(seed: game.seed)
    game.players.each_with_index do |player, index|
      PlayerRecord.create_from(player, gr, index)
    end
    game.events.each_with_index do |event, index|
      EventRecord.create_from(event, gr, index)
    end
    gr
  end

end