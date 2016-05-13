class GoodBrain < Brain

  def initialize(role)
    # You might want to copy down your role.
    @role = role
    @team_vote_records = {}
    @mission_votes = {}
  end

  def show_team_votes(players_to_votes)
    # Shows the votes made on the last team voted on.
    # players_to_votes is a hash with players as keys and
    # votes as values. { player1 => true}.
    # Return value is unused.
    @team_vote_records[api.current_mission_number] ||= {}
    mission_records = @team_vote_records[api.current_mission_number]
    mission_records[api.current_leader] = players_to_votes
  end

  def show_mission_votes(votes)
    @mission_votes[api.current_mission_number] = votes
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
      # (team & spies).length != api.current_number_of_fails_needed
      team.include?(api.name)
    end

    def pick_team(number_of_team_members)
      # As leader, pick a team to go on a mission.
      # Return value is an array of Players.
      picks = [api.name]
      i = 0
      spy_count = 1
      while not_enough_picks?(picks, number_of_team_members) do
        if iterated_too_far?(i, api.player_names.length)
          picks << first_unpicked_player(api.player_names, picks)
        else
          player = api.player_names[i]
          if player_is_a_spy?(player)
            if more_spies_are_needed?(spy_count, api.current_number_of_fails_needed)
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

    def pass_mission?(team)
      # Return value is true or true, indicating
      # whether or not to pass the mission.
      false
    end

    def not_enough_picks?(picks, number_of_team_members)
      picks.length != number_of_team_members
    end

    def iterated_too_far?(i, number_of_players)
      i >= number_of_players
    end

    def first_unpicked_player(player_names, picks)
      (player_names - picks).first
    end

    def player_is_a_spy?(player)
      spies.include?(player)
    end

    def more_spies_are_needed?(spy_count, number_of_fails_needed)
      spy_count < number_of_fails_needed
    end
  end

  class ResistanceBrain < GoodBrain
    def initialize(role)
      super(role)
      @suspicions = Hash.new { |h,k| h[k] = 0 }
      @current_mission_number = 0
      @failed_team_proposals = 0
      @failing_members = []
      @last_team_vote = nil
    end

    def accept_team?(team)
      # Return true or false. True approves
      # of the team
      if @current_mission_number != api.current_mission_number
        @current_mission_number = api.current_mission_number
        @failed_team_proposals = 0
      end
      if @failed_team_proposals == 4
        @last_team_vote = true
      else
        populate_suspicions
        avg_team_suspicion = team.reduce(0) {|a, i| a += @suspicions[i]} / team.count
        avg_others_suspicion =  (api.player_names - team).reduce(0) {|a, i| a += @suspicions[i]} / (api.player_names - team).count
        @last_team_vote = avg_team_suspicion < avg_others_suspicion
      end
      # puts "      #{api.name}: #{@suspicions}"
      @last_team_vote
    end

    def pick_team(team_members)
      # As leader, pick a team to go on a mission.
      # Return value is an array of Players.
      populate_suspicions
      @suspicions.sort_by {|k,v| v}.first(team_members).to_h.keys
    end

    def show_mission_votes(votes)
      super(votes)
      vote_counts = votes.each_with_object(Hash.new(0)) { |vote,counts| counts[vote] += 1 }
      vote_counts[false].times do
        api.current_team.each do |player|
          update_suspicion(player, 2)
        end
      end
      if vote_counts[true] > 0 && vote_counts[false] == 0
        api.current_team.each do |player|
          update_suspicion(player, -1)
        end
      end
      # if vote_counts[false] >= api.current_number_of_fails_needed
      #   @failing_members += api.current_team
      #   api.current_team.each {|p| @suspicions[p] += 1 unless p == api.name }
      # end
    end

    def show_team_votes(players_to_votes)
      super(players_to_votes)
      @failed_team_proposals += 1 if players_to_votes.count(false) >= players_to_votes.count(true)
      populate_suspicions
      players_to_votes.each_pair do |player, vote|
        incorrect_vote = !api.current_team.include?(player)
        update_suspicion(player) if incorrect_vote
      end
    end

    def populate_suspicions
      api.player_names.each { |name| @suspicions[name] }
    end

    def update_suspicion(player, increment=1)
      @suspicions[player] += increment unless player == api.name
    end
  end
end
