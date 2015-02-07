class Player

  attr_reader :brain, :role, :previous_player
  attr_accessor :next_player
  def initialize(brain, role, previous_player)
    @brain          = brain
    @role           = role
    # TODO introduce PlayerAPI layer to make braining possible
    self.previous_player= previous_player if previous_player
  end

  def spy?
    role == 'spy'
  end

  def open_eyes(spies)
    others = spies.clone
    others.delete(self)
    brain.open_eyes(others)
  end

  def previous_player=(previous_player)
    @previous_player            = previous_player
    previous_player.next_player = self
  end

  delegate :vote, to: :brain
  delegate :pick_team, to: :brain
  delegate :show_player_votes, to: :brain
  delegate :pass_mission?, to: :brain
  delegate :show_mission_plays, to: :brain

  def ==(other)
    brain == other.brain && role == other.role
  end
end