class Game
  attr_reader :players, :random, :seed
  def initialize(brain_classes, seed=nil)
    if seed #this is just for deterministic testing
      @seed = seed
      @random = Random.new(seed)
    else
      @random = Random.new
      @seed = random.seed
    end
    roles = roles_for(brain_classes.size)
    @players = brain_classes.each_with_index.map do |bc, i|
      role = roles[i]
      Player.new(bc.new(role), role)
    end
  end

  def play


  end

  def self.all_roles
    %w{ resistance spy resistance spy resistance
        resistance spy resistance resistance spy }
  end

  private
  def roles_for(players)
    self.class.all_roles[0..players - 1].shuffle(random: random)
  end
end