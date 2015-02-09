class Mission

  attr_reader :leader, :players, :mission_number, :game_over, :winning_team
  alias_method :game_over?, :game_over

  def initialize(leader, players, mission_number)
    @leader         = leader
    @players        = players
    @mission_number = mission_number
    @game_over = false
  end

  def play
    votes_failed = 0
    # TODO: team size
    team = leader.pick_team
    vote_passes = vote(team)
    while !vote_passes
      votes_failed += 1
      if votes_failed == 5
        @game_over = true
        return
      end
      @leader = leader.next_player
      team = leader.pick_team
      vote_passes = vote(team)
    end
    if vote_passes
      mission(team)
    end
  end

  def team_members
    players_to_sizes[players.length][mission_number - 1]
  end

  private
  def players_to_sizes
    { 5 =>  [2,3,2,3,3],
      6 =>  [2,3,4,3,4],
      7 =>  [2,3,3,4,4],
      8 =>  [3,4,4,5,5],
      9 =>  [3,4,4,5,5],
      10 => [3,4,4,5,5]}
  end

  def vote(team)
    players_to_votes = {}
    players.each do |player|
      players_to_votes[player] = player.vote(team)
    end
    votes = players_to_votes.values
    grouped_votes = votes.group_by { |v| v }
    approve_votes    = grouped_votes[true].try(:count)  || 0
    disapprove_votes = grouped_votes[false].try(:count) || 0
    players.each { |p| p.show_player_votes(players_to_votes) }
    approve_votes > disapprove_votes
  end

  def mission(team)
    spies = team.find_all { |p| p.spy? }
    votes = spies.map { |p| p.pass_mission?(team) }
    votes += (team.length - spies.length).times.map {true}
    players.each { |p| p.show_mission_plays(votes.group_by {|o| o })}
    if votes.include?(false)
      # TODO mission 4 in 7+ player games
      # TODO eventing makes printing possible :/
      @winning_team = 'spy'
    else
      @winning_team = 'resistance'
    end
  end
end