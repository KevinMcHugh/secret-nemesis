class Event
  def initialize(event_listener)
    event_listener.notify(self)
  end
end
