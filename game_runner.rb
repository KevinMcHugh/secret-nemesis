1.times do

  brain_classes = 0.times.map {VeryNegativeBrain}
  brain_classes += 0.times.map {CrazyBrain}
  brain_classes += 0.times.map {VeryPositiveBrain}
  brain_classes += 5.times.map {GoodBrainWithAutono}
  game = Game.new(brain_classes)
  game.play

  record = PersistGame.new(game).execute
  record.event_records.each do |er|
    s = JSON.parse(er.event_json)['to_s']
    puts s
  end
end
# binding.pry
