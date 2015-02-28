games = 10000.times.flat_map do |i|
  brain_classes = []
  # brain_classes += 2.times.map {VeryNegativeBrain}
  # brain_classes += 2.times.map {CrazyBrain}
  # brain_classes += 2.times.map {VeryPositiveBrain}
  brain_classes += 5.times.map {GoodBrain}

  game = Game.new(brain_classes)
  game.play
  game
end

winners = games.map {|game| game.winners.map(&:role).uniq }
role_counter = Hash.new(0)
winners.reduce(role_counter){ |h, e| h[e] += 1 ; h }

pp role_counter.sort_by {|key, value| value}
