class MissionStartedEvent < Event

  def initialize(event_listener, mission_number)
    @mission_number = mission_number
    super(event_listener)
  end

  def to_s; "Mission #{@mission_number.to_s} started"; end
end