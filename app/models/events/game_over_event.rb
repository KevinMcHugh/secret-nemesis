class GameOverEvent < Event

  def initialize(event_listener, winning_team)
    @winning_team = winning_team
    super(event_listener)
  end

  def to_s
    "Game Over. Winners: #{@winning_team}"
  end
end