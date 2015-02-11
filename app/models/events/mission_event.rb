class MissionEvent < Event
  def initialize(event_listener, votes, winning_team, mission_number)
    @votes          = votes
    @winning_team   = winning_team
    @mission_number = mission_number
    super(event_listener)
  end

  def to_s
    "   #{@winning_team} win  #{@mission_number} with: #{@votes}"
  end
end