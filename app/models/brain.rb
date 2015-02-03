# Demonstrates all the methods you need to
# implement in your brain.
class Brain

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

  def pass_mission?
    # Return value is true or false, indicating
    # whether or not to pass the mission.
  end
end