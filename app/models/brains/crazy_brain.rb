class CrazyBrain < Brain

  def initialize(role)
    # You might want to copy down your role.
    @role = role
    @random = Random.new
  end

  def open_eyes(other_spies)
    # Reveals spies to each other. Return
    # value is unused.
    # IM CRAZY
  end

  def vote(team)
    # Return true or false. True approves
    # of the team
    heh_heh_heh_heh
  end

  def pick_team(team_members)
    # As leader, pick a team to go on a mission.
    # Return value is an array of Players.
    api.player_names.sample(team_members)
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
    # Return value is true or true, indicating
    # whether or not to pass the mission.
    heh_heh_heh_heh
  end

  def heh_heh_heh_heh
    [true, false].sample
  end
end