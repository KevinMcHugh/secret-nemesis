(5..10).each do |i|
  results = RunLotsOfGames.new(number_of_players: i).perform
  puts "#{i} players"
  pp results
end