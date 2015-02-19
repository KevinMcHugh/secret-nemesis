class Mission

  attr_reader :event_listener, :leader, :players, :mission_number, :game_over, :winning_team
  alias_method :game_over?, :game_over

  def initialize(event_listener, leader, players, mission_number)
    @event_listener = event_listener
    @leader         = leader
    @players        = players
    @mission_number = mission_number
    @game_over = false
  end

  def play
    MissionStartedEvent.new(event_listener, mission_number)
    teams_proposed = 0
    vote_passes = false
    while !vote_passes
      team = leader.pick_team(team_members)
      teams_proposed += 1
      TeamProposedEvent.new(event_listener, mission_number, leader, team, teams_proposed)
      vote_passes = vote(team)
      if stalemate?(teams_proposed, vote_passes)
        end_game
        return
      end
      @leader = leader.next_player
    end
    mission(team)
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
      players_to_votes[player] = player.accept_team?(team)
    end
    votes = players_to_votes.values
    grouped_votes = votes.group_by { |v| v }
    approve_votes    = grouped_votes[true].try(:count)  || 0
    disapprove_votes = grouped_votes[false].try(:count) || 0
    players.each { |p| p.show_team_votes(players_to_votes) }

    votes_passes = approve_votes > disapprove_votes
    VoteEvent.new(event_listener, team, players_to_votes, votes_passes)
    votes_passes
  end

  def stalemate?(teams_proposed, vote_passes)
    teams_proposed == 5 && !vote_passes
  end

  def end_game
    @game_over = true
    @winning_team = 'spy'
  end

  def fails_needed
    if players.length >= 7 && mission_number == 4
      2
    else
      1
    end
  end

  def mission(team)
    votes = team.map do |p|
      p.spy? ? p.pass_mission?(team) : true
    end
    players.each { |p| p.show_mission_votes(votes.group_by {|o| o })}
    if votes.count(false) >= fails_needed
      @winning_team = 'spy'
    else
      @winning_team = 'resistance'
    end
    MissionEvent.new(event_listener, votes, winning_team, mission_number)
  end
end