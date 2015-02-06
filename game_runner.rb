brain_classes = 4.times.map {Brain}
game = Game.new(brain_classes).play
binding.pry