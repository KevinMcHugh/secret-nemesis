class Player

  attr_reader :brain, :role, :previous_player, :player_api, :name
  attr_accessor :next_player
  def initialize(brain, role, previous_player)
    @brain          = brain
    @role           = role
    @player_api     = PlayerToBrainApi.new(self, brain)
    @name = rand(100)

    brain.api= player_api
    self.previous_player= previous_player if previous_player
  end

  def spy?
    role == 'spy'
  end

  def open_eyes(spies)
    others = spies.clone
    others.delete(self)
    player_api.open_eyes(others)
  end

  def previous_player=(previous_player)
    @previous_player            = previous_player
    previous_player.next_player = self
  end

  def players
    unless @players
      @players = [self]
      np = next_player
      while np != self
        players << np
        np = np.next_player
      end
    end
    @players
  end

  delegate :accept_team?,                    to: :player_api
  delegate :pick_team,                       to: :player_api
  delegate :show_team_votes,                 to: :player_api
  delegate :pass_mission?,                   to: :player_api
  delegate :show_mission_votes,              to: :player_api
  delegate :current_mission_number=,         to: :player_api
  delegate :current_leader=,                 to: :player_api
  delegate :current_number_of_fails_needed=, to: :player_api
  delegate :add_mission_winner,              to: :player_api

  def ==(other)
    brain == other.brain && role == other.role
  end

  def to_s; "#{name}|#{brain.class}|#{role}"; end
  def inspect; to_s; end
end