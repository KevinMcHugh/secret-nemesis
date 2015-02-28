class VeryPositiveBrain < Brain
  def self.spy_class; self::OnlyBrain; end
  def self.resistance_class; self::OnlyBrain; end
  class OnlyBrain < VeryPositiveBrain
    def initialize(role)
      # You might want to copy down your role.
      @role = role
    end

    def open_eyes(other_spies)
      # Reveals spies to each other. Return
      # value is unused.
      @other_spies = other_spies
    end

    def accept_team?(team)
      # Return true or false. True approves
      # of the team
      true
    end

    def pick_team(team_members)
      # As leader, pick a team to go on a mission.
      # Return value is an array of Players.
      api.player_names.first(team_members)
    end

    def show_team_votes(players_to_votes)
      # Shows the votes made on the last team voted on.
      # players_to_votes is a hash with players as keys and
      # votes as values. { player1 => true}.
      # Return value is unused.
    end

    def show_mission_votes(players_to_votes)
    end

    def pass_mission?(team)
      # Return value is true or true, indicating
      # whether or not to pass the mission.
      true
    end
  end
end