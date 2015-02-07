class PlayerToBrainApi

  attr_reader :brain
  def initialize(player, brain)
    @player = player
    @brain  = brain
  end

  def open_eyes(other_spies)
    brain.open_eyes(other_spies.map(&:name))
  end

  def vote(team)
    brain.vote(team.map(&:name))
  end

  def pick_team
    brain.pick_team
  end

  def show_player_votes(players_to_votes)
    result = {}
    players_to_votes.each_pair do |player, vote|
      result[player.name] = vote
    end
    brain.show_player_votes(result)
  end

  def show_mission_plays(grouped_votes)
    brain.show_mission_plays(grouped_votes.values.flatten)
  end

  def pass_mission?(team)
    brain.pass_mission?(team.map(&:name))
  end

  def player_names
    @player.players.map(&:name)
  end

  def name
    @player.name
  end

  private
  def instance_variable_get(variable)
    fail 'Not allowed.'
  end
end