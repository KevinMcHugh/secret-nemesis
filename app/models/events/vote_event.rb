class VoteEvent < Event

  def initialize(event_listener, team, players_to_votes, vote_passes)
    @team = team
    @players_to_votes = players_to_votes
    @vote_passes = vote_passes
    super(event_listener)
  end

  def to_s
    "     Vote #{pass_or_fail} on #{@team}: \n" +
      @players_to_votes.map { |player,vote| "    #{player}:#{vote}" }.join("\n")
  end

  def pass_or_fail
    @vote_passes ? 'passes' : 'fails'
  end
end