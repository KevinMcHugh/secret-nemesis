class Mission

  attr_reader :leader, :players, :game_over
  alias_method :game_over?, :game_over

  def initialize(leader, players)
    @leader    = leader
    @players   = players
    @game_over = false
  end

  def play
    votes_failed = 0
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
      team.each { |p| p.pass_mission? }
    end
  end

  def winning_team; nil; end

  private
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
end