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
    team = leader.pick_team(team_members)
    vote_passes = vote(team)
    puts "  Starting mission #{mission_number}"
    puts "  #{leader.to_s} has chosen #{team}"
    puts "    and the vote #{vote_passes ? 'passes' : 'failed'}"
    while !vote_passes
      votes_failed += 1
      if votes_failed == 5
        @game_over = true
        @winning_team = 'spy'
        return
      end
      @leader = leader.next_player
      team = leader.pick_team(team_members)
      vote_passes = vote(team)
      puts "  #{leader.to_s} has chosen #{team}"
      puts "    and the vote #{vote_passes ? 'passes' : 'failed'}"
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
    approve_votes > disapprove_votes
  end

  def mission(team)
    votes = team.map do |p|
      p.spy? ? p.pass_mission?(team) : true
    end
    puts "   The votes are in: #{votes}"
    players.each { |p| p.show_mission_votes(votes.group_by {|o| o })}
    if votes.include?(false)
      # TODO mission 4 in 7+ player games
      # TODO eventing makes printing possible :/
      @winning_team = 'spy'
    else
      @winning_team = 'resistance'
    end
  end
end