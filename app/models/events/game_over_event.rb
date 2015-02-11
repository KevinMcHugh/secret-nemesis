class GameOverEvent < Event

  def initialize(event_listener, winning_team)
    @winning_team = winning_team
    super(event_listener)
  end
end