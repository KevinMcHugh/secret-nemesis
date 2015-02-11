class TeamProposedEvent < Event
  def initialize(event_listener, mission_number, leader, team_members, team_proposed)
    @mission_number = mission_number
    @leader = leader
    @team_members = team_members
    @team_proposed = team_proposed
    super(event_listener)
  end

  def to_s
    "   Team #{@team_proposed}: #{@leader} picked #{@team_members}"
  end
end