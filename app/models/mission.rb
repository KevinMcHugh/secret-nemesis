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
    votes_failed = 0
    # TODO: team size
    team = leader.pick_team(team_members)
    TeamProposedEvent.new(event_listener, mission_number, leader, team, votes_failed + 1)
    vote_passes = vote(team)
    while !vote_passes
      votes_failed += 1
      if votes_failed == 5
        @game_over = true
        @winning_team = 'spy'
        return
      end
      @leader = leader.next_player
      team = leader.pick_team(team_members)
      TeamProposedEvent.new(event_listener, mission_number, leader, team, votes_failed + 1)
      vote_passes = vote(team)
    end
    mission(team) if vote_passes
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

  def mission(team)
    votes = team.map do |p|
      p.spy? ? p.pass_mission?(team) : true
    end
    players.each { |p| p.show_mission_votes(votes.group_by {|o| o })}
    if votes.include?(false)
      # TODO mission 4 in 7+ player games
      # TODO eventing makes printing possible :/
      @winning_team = 'spy'
    else
      @winning_team = 'resistance'
    end
    MissionEvent.new(event_listener, votes, winning_team, mission_number)
  end
end