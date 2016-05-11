class GoodBrainWithAutono < GoodBrain

  def self.spy_class; SpyBrain; end
  def self.resistance_class; AutoNoResistanceBrain; end

  class AutoNoResistanceBrain < ResistanceBrain
    def accept_team?(team)
      # Return true or false. True approves
      # of the team
      return false if @current_mission_number == 0 && @failed_team_proposals == 0
      super
    end
  end
end
