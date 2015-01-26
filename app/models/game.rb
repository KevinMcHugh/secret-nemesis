class Game
  attr_reader :players, :random, :seed, :spy_wins, :resistance_wins
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
  end

  def play
    spies.map do |spy|
      spy.open_eyes(spies)
    end
    leader = @players.first
    while spy_wins < 3 && resistance_wins < 3
      mission = mission(leader)
      leader = mission.leader.next
      mission.winning_team == 'spy' ? @spy_wins += 1 : @resistance_wins += 1
    end
  end

  def winning_team
    if spy_wins == 3
      'spy'
    elsif resistance_wins == 3
      'resistance'
    else
      nil
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

  def mission(leader)
    Mission.new(leader, players)
  end
end