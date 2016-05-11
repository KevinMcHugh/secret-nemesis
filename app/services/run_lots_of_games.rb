class RunLotsOfGames

  attr_reader :number_of_games, :number_of_players
  def initialize(number_of_games: 1000, number_of_players: 5)
    @number_of_games   = number_of_games
    @number_of_players = number_of_players
  end


  def perform
    games = number_of_games.times.flat_map do |i|
      brain_classes = []
      # brain_classes += 2.times.map {VeryNegativeBrain}
      # brain_classes += 2.times.map {CrazyBrain}
      # brain_classes += 2.times.map {VeryPositiveBrain}
      brain_classes += (number_of_players).times.map {GoodBrain}
      # brain_classes += (number_of_players).times.map {GoodBrainWithAutono}
#
      game = Game.new(brain_classes)
      game.play
      game
    end

    winners = games.map {|game| game.winners.map(&:role).uniq }
    role_counter = Hash.new(0)
    winners.reduce(role_counter){ |h, e| h[e] += 1 ; h }

    role_counter.sort_by {|key, value| value}
  end

end