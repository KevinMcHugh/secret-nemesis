class Player

  attr_reader :brain, :role
  def initialize(brain, role)
    @brain = brain
    @role  = role
  end

  def ==(other)
    brain == brain && role == role
  end
end