class Mission

  attr_reader :leader, :players
  def initialize(leader, players)
    @leader  = leader
    @players = players
  end

  def play
    team = leader.pick_team
    vote_passes = vote(team)
    if vote_passes
      team.each { |p| p.pass_mission? }
    else
      @leader = leader.next
      team = leader.pick_team
      vote(team)
    end
  end

  def winning_team; nil; end

  private
  def vote(team)
    votes = players.map { |p| p.vote(team) }
    grouped_votes = votes.group_by { |v| v }
    approve_votes    = grouped_votes[true].try(:count)  || 0
    disapprove_votes = grouped_votes[false].try(:count) || 0
    approve_votes > disapprove_votes
  end
end