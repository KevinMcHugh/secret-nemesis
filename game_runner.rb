1.times do

  brain_classes = 0.times.map {VeryNegativeBrain}
  brain_classes += 5.times.map {CrazyBrain}
  brain_classes += 0.times.map {VeryPositiveBrain}
  game = Game.new(brain_classes).play
end
# binding.pry