class GoodBrain < Brain

  def initialize(role)
    # You might want to copy down your role.
    @role = role
  end

  class SpyBrain < GoodBrain
    attr_reader :spies

    def open_eyes(other_spies)
      @spies = other_spies
      @spies << api.name
    end

    def accept_team?(team)
      # Return true or false. True approves
      # of the team
      (team & spies).length != api.current_number_of_fails_needed
    end

    def pick_team(number_of_team_members)
      # As leader, pick a team to go on a mission.
      # Return value is an array of Players.
      picks = [api.name]
      i = 0
      spy_count = 1
      while picks.length != number_of_team_members do
        if i >= api.player_names.length
          picks << (api.player_names - picks).first
        else
          player = api.player_names[i]
          if spies.include?(player)
            if spy_count < api.current_number_of_fails_needed
              picks << player
              spy_count += 1
            end
          else
            picks << player
          end
          i += 1
          picks = picks.uniq
        end
      end
      picks
    end

    def show_team_votes(players_to_votes)
      # Shows the votes made on the last team voted on.
      # players_to_votes is a hash with players as keys and
      # votes as values. { player1 => true}.
      # Return value is unused.
      api.name
      api.current_team
      api.current_leader
      api.current_mission_number
      api.current_number_of_fails_needed
      api.mission_winners
    end

    def show_mission_votes(players_to_votes)
    end

    def pass_mission?(team)
      # Return value is true or true, indicating
      # whether or not to pass the mission.
      false
    end
  end

  class ResistanceBrain < GoodBrain
    def accept_team?(team)
      # Return true or false. True approves
      # of the team
      true
    end

    def pick_team(team_members)
      # As leader, pick a team to go on a mission.
      # Return value is an array of Players.
      api.player_names.first(team_members)
    end
  end
end