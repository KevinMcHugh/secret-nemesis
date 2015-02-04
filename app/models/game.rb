class Game
  attr_reader :players, :random, :seed, :spy_wins, :resistance_wins, :winning_team
  def initialize(brain_classes, seed=nil)
    @seed = seed ? seed : Random.new.seed #this is just for deterministic testing
    @random = Random.new(seed)
    roles = roles_for(brain_classes.size)
    @players = brain_classes.each_with_index.map do |bc, i|
      role = roles[i]
      Player.new(bc.new(role), role)
    end
    @spy_wins        = 0
    @resistance_wins = 0
    @winning_team    = nil
  end

  def play
    reveal_spies
    leader = @players.first
    while !winning_team
      mission = mission(leader)
      if mission.game_over?
        @winning_team = 'spy'
      else
        leader = mission.leader.next
        if mission.winning_team == 'spy'
          @spy_wins += 1
        elsif mission.winning_team == 'resistance'
          @resistance_wins += 1
        end
        set_winner
      end
    end
  end

  def self.all_roles
    %w{ resistance spy resistance spy resistance
        resistance spy resistance resistance spy }
  end

  private
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

  def mission(leader)
    Mission.new(leader, players)
  end

  def set_winner
    if spy_wins == 3
      @winning_team = 'spy'
    elsif resistance_wins == 3
      @winning_team = 'resistance'
    end
  end
end