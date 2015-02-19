class PlayerToBrainApi

  attr_reader :brain
  def initialize(player, brain)
    @player = player
    @brain  = brain
  end

  def open_eyes(other_spies)
    brain.open_eyes(other_spies.map(&:name))
  end

  def accept_team?(team)
    brain.accept_team?(team.map(&:name))
  end

  def pick_team(team_members)
    names = brain.pick_team(team_members)
    #TODO team size validation
    names.map do |name|
      @player.players.find {|player| player.name == name }
    end
  end

  def show_team_votes(players_to_votes)
    result = {}
    players_to_votes.each_pair do |player, vote|
      result[player.name] = vote
    end
    brain.show_team_votes(result)
  end

  def show_mission_votes(grouped_votes)
    brain.show_mission_votes(grouped_votes.values.flatten)
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