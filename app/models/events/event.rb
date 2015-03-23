class Event
  def initialize(event_listener)
    event_listener.notify(self)
  end

  def as_json(options={})
    each_instance_variable do |variable|
      if variable.is_a? Class
        variable.to_s
      else
        variable.as_json
      end
    end
  end

  def each_instance_variable(&block)
    hash = {}
    hash[:@type] = self.class.to_s
    hash[:@to_s] = to_s
    instance_variables.each do |variable|
      hash[variable] = block.call(instance_variable_get(variable))
    end
    hash
  end
end
