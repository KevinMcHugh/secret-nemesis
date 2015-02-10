class Game
  attr_reader :players, :random, :seed, :spy_wins, :resistance_wins, :winning_team
  def initialize(brain_classes, seed=nil)
    @seed = seed ? seed : Random.new.seed #this is just for deterministic testing
    @random = Random.new(@seed)
    set_up_players(brain_classes)
    @spy_wins        = 0
    @resistance_wins = 0
    @winning_team    = nil
    @events          = []
  end

  def play
    reveal_spies
    leader = @players.first
    mission_number = 1
    while !winning_team
      mission = mission(leader, mission_number)
      mission.play
      puts "Mission #{mission_number} won by #{mission.winning_team}"
      mission_number += 1
      if mission.game_over?
        @winning_team = 'spy'
      else
        leader = mission.leader.next_player
        if mission.winning_team == 'spy'
          @spy_wins += 1
        elsif mission.winning_team == 'resistance'
          @resistance_wins += 1
        end
        set_winner
      end
    end
    puts "Game won by #{winning_team}"
  end

  def self.all_roles
    %w{ resistance spy resistance spy resistance
        resistance spy resistance resistance spy }
  end

  def notify(event)
    @events << event
  end

  private
  def set_up_players(brain_classes)
    previous_player = nil
    roles = roles_for(brain_classes.length)
    @players = brain_classes.each_with_index.map do |bc, i|
      role = roles[i]
      player = Player.new(bc.new(role), role, previous_player)
      previous_player = player
      player
    end
    players.first.previous_player = previous_player
  end

  def roles_for(players)
    self.class.all_roles[0..players - 1].shuffle(random: random)
  end

  def spies
    @spies ||= players.find_all(&:spy?)
  end

  def reveal_spies
    spies.map do |spy|
      spy.open_eyes(spies)
    end
  end

  def mission(leader, mission_number)
    Mission.new(leader, players, mission_number)
  end

  def set_winner
    if spy_wins == 3
      @winning_team = 'spy'
    elsif resistance_wins == 3
      @winning_team = 'resistance'
    end
  end
end