# Demonstrates all the methods you need to
# implement in your brain.
class Brain

  def initialize(role)
    # You might want to copy down your role.
  end

  def open_eyes(other_spies)
    # Reveals spies to each other. Return
    # value is unused.
  end

  def vote(team)
    # Return true or false. True approves
    # of the team
  end

  def pick_team
    # As leader, pick a team to go on a mission.
    # Return value is an array of Players.
  end

  def show_player_votes(players_to_votes)
    # Shows the votes made on the last team voted on.
    # players_to_votes is a hash with players as keys and
    # votes as values. { player1 => true}.
    # Return value is unused.
  end

  def show_mission_plays(players_to_votes)
  end

  def pass_mission?(team)
    # Return value is true or false, indicating
    # whether or not to pass the mission. This method is
    # only called for spies. Resistance members must pass
    # missions.
  end
end