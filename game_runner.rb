brain_classes = 5.times.map {VeryNegativeBrain}
game = Game.new(brain_classes).play
binding.pry