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

  def ==(other)
    brain == other.brain && role == other.role
  end
end