class Game
  attr_reader :players, :random, :seed
  def initialize(brain_classes, seed=nil)
    @seed = seed ? seed : Random.new.seed #this is just for deterministic testing
    @random = Random.new(seed)
    roles = roles_for(brain_classes.size)
    @players = brain_classes.each_with_index.map do |bc, i|
      role = roles[i]
      Player.new(bc.new(role), role)
    end
  end

  def play
    spies.map do |spy|
      spy.open_eyes(spies)
    end
    leader = @players.first
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
end