winners = 1000.times.flat_map do |i|
  brain_classes = []
  # brain_classes += 2.times.map {VeryNegativeBrain}
  # brain_classes += 2.times.map {CrazyBrain}
  # brain_classes += 2.times.map {VeryPositiveBrain}
  brain_classes += 5.times.map {GoodBrain}

  game = Game.new(brain_classes)
  game.play
  game.winners
end

brain_counter = Hash.new(0)
winners.map(&:brain).map(&:class).reduce(brain_counter){ |h, e| h[e] += 1 ; h }
role_counter = Hash.new(0)
winners.map(&:role).reduce(role_counter){ |h, e| h[e] += 1 ; h }

pp brain_counter.sort_by {|key, value| value}
pp role_counter.sort_by {|key, value| value}
# binding.pry
# a = ''
