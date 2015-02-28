class Game
  attr_reader :players, :random, :seed, :spy_wins,
   :resistance_wins, :winning_team, :events, :current_mission, :missions
  def initialize(brain_classes, seed=nil)
    @seed = seed ? seed : Random.new.seed #this is just for deterministic testing
    @random = Random.new(@seed)
    set_up_players(brain_classes)
    @spy_wins        = 0
    @resistance_wins = 0
    @winning_team    = nil
    @events          = []
    @missions        = []
  end

  def play
    reveal_spies
    leader = @players.first
    mission_number = 1
    while !winning_team
      @current_mission = mission(leader, mission_number)
      @missions << current_mission
      current_mission.play
      mission_number += 1
      if current_mission.game_over?
        @winning_team = 'spy'
      else
        leader = current_mission.leader.next_player
        set_winner(current_mission)
      end
    end
    GameOverEvent.new(self, winning_team)
  end

  def self.all_roles
    %w{ resistance spy resistance spy resistance
        resistance spy resistance resistance spy }
  end

  def notify(event)
    @events << event
  end

  def mission_winners
    @missions.map(&:winning_team)
  end

  private
  def set_up_players(brain_classes)
    previous_player = nil
    roles = roles_for(brain_classes.length)
    @players = brain_classes.each_with_index.map do |bc, i|
      role = roles[i]
      player = Player.new(self, bc.new_for(role), role, previous_player)
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
    Mission.new(self, leader, players, mission_number)
  end

  def set_winner(current_mission)
    if current_mission.winning_team == 'spy'
      @spy_wins += 1
    elsif current_mission.winning_team == 'resistance'
      @resistance_wins += 1
    end
    check_for_game_winner
  end

  def check_for_game_winner
    if spy_wins == 3
      @winning_team = 'spy'
    elsif resistance_wins == 3
      @winning_team = 'resistance'
    end
  end
end