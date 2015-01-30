class Player

  attr_reader :brain, :role
  def initialize(brain, role)
    @brain = brain
    @role  = role
  end

  def spy?
    role == 'spy'
  end

  def open_eyes(spies)
    others = spies.clone
    others.delete(self)
    brain.open_eyes(others)
  end

  def show_player_votes(players_to_votes)
    brain.show_player_votes(players_to_votes)
  end

  def next; nil; end
  def vote(team); nil; end
  def pick_team; nil; end
  def pass_mission?; nil; end

  def ==(other)
    brain == other.brain && role == other.role
  end
end