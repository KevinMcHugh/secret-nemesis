require 'spec_helper'

describe Mission do
  let(:brain1) { double('brain1', show_team_votes: nil,
    pass_mission?: false, show_mission_votes: nil, :api= => nil)}
  let(:brain2) { double('brain2', show_team_votes: nil,
    pass_mission?: false, show_mission_votes: nil, accept_team?: nil, :api= => nil)}
  let(:player1) { Player.new(brain1, 'spy', nil)}
  let(:player2) { Player.new(brain2, 'resistance', player1)}
  let(:player3) { Player.new(brain2, 'resistance', player2)}
  let(:player4) { Player.new(brain2, 'resistance', player3)}
  let(:player5) { Player.new(brain2, 'resistance', player4)}

  let(:listener) { double('listener', notify: nil)}
  let(:players) { [player1, player2, player3, player4, player5]}
  let(:mission_number) { 1 }
  subject { described_class.new(listener, player1, players, mission_number) }
  describe '#initialize' do
    it 'accepts a leader, players and mission number' do
      expect(subject.leader).to eql(player1)
      expect(subject.players).to eql(players)
      expect(subject.mission_number).to eql(1)
    end

    it 'picks the correct number of team members' do
      expect(subject.team_members).to eql(2)
    end
  end

  describe '#play' do
    before do
      allow(player1).to receive(:pick_team).and_return(players)
      allow(player1).to receive(:accept_team?).with(players).and_return(true)
      allow(player2).to receive(:accept_team?).with(players).and_return(true)
      allow(player3).to receive(:accept_team?).with(players).and_return(true)
      allow(player4).to receive(:accept_team?).with(players).and_return(true)
      allow(player5).to receive(:accept_team?).with(players).and_return(false)
      allow(player1).to receive(:show_mission_votes)
      allow(player2).to receive(:show_mission_votes)
    end

    it 'asks the leader to pick a team' do
      expect(player1).to receive(:pick_team).with(2)
      subject.play
    end

    it 'puts the picked team to a vote' do
      expect(player1).to receive(:accept_team?).with(players)
      expect(player2).to receive(:accept_team?).with(players)
      subject.play
    end

    it 'reveals votes to all players' do
      expect(player1).to receive(:show_team_votes).with({player1 => true,
        player2 => true, player3 => true, player4 => true, player5 => false})
      expect(player2).to receive(:show_team_votes).with({player1 => true,
        player2 => true, player3 => true, player4 => true, player5 => false})
      subject.play
    end

    context 'the vote passes' do
      before do
        allow(player1).to receive(:accept_team?).with(players).and_return(true)
        allow(player2).to receive(:accept_team?).with(players).and_return(true)
      end

      it 'asks the spies if they want to pass the mission' do
        expect(player1).to receive(:pass_mission?).with(players)
        expect(player2).not_to receive(:pass_mission?)
        subject.play
      end

      it 'reveals the mission plays' do
        expect(player1).to receive(:show_mission_votes).with({true => [true, true, true, true],
          false => [false]})
        expect(player2).to receive(:show_mission_votes).with({true => [true, true, true, true],
          false => [false]})
        expect(player1).to receive(:pass_mission?).and_return(false)
        subject.play
      end

      it 'tells players useful information' do
        players.each do |player|
          expect(player).to receive(:current_mission_number=).with(mission_number)
          expect(player).to receive(:current_leader=).with(player1)
          expect(player).to receive(:current_leader=).with(player2)
          expect(player).to receive(:current_number_of_fails_needed=).with(1)
          expect(player).to receive(:add_mission_winner).with('spy')
        end
        subject.play
      end

      context 'the spies pass the mission' do
        it 'sets the winning team to resistance' do
          expect(player1).to receive(:pass_mission?).and_return(true)
          subject.play
          expect(subject.winning_team).to eq('resistance')
        end
      end

      context 'the spies fail the mission' do
        before { allow(player1).to receive(:pass_mission?).and_return(false) }

        it 'sets the winning team to spy' do
          subject.play
          expect(subject.winning_team).to eq('spy')
        end
        context 'with fewer than 7 players' do
          context 'when the mission is number 4' do
            let(:mission_number) { 4 }
            it 'only requires one fail to fail' do
              subject.play
              expect(subject.winning_team).to eq('spy')
            end
          end
        end

        context 'with at least 7 players' do
          let(:player6) { Player.new(brain2, 'resistance', player5)}
          let(:player7) { Player.new(brain1, 'spy',        player6)}
          let(:players) { [player1, player2, player3, player4, player5, player6, player7]}

          before do
            allow(player6).to receive(:accept_team?).with(players).and_return(true)
            allow(player7).to receive(:accept_team?).with(players).and_return(false)
            allow(player7).to receive(:pass_mission?).and_return(true)
          end
          context 'when the mission is not number 4' do
            it 'takes one to fail' do
              subject.play
              expect(subject.winning_team).to eq('spy')
            end
          end
          context 'when the mission is number 4' do
            let(:mission_number) { 4 }
            context 'with 1 fail' do
              it 'the resistance wins' do
                subject.play
                expect(subject.winning_team).to eq('resistance')
              end
            end
            context 'with 2 fails' do
              before { allow(player7).to receive(:pass_mission?).and_return(false) }
              it 'the spies win' do
                subject.play
                expect(subject.winning_team).to eq('spy')
              end
            end
          end
        end
      end
    end

    context 'the vote fails' do
      it 'asks the next leader to pick a team' do
        expect(player2).to receive(:pick_team).and_return(players)
        expect(player1).to receive(:next_player).and_return(player2)
        expect(player1).to receive(:accept_team?).with(players).and_return(false)
        expect(player2).to receive(:accept_team?).with(players).and_return(false)
        subject.play
      end

      context 'the vote fails 5 times' do
        it 'the game is over' do
          expect(player2).to receive(:pick_team).exactly(2).times.and_return(players)
          expect(player1).to receive(:next_player).exactly(2).times.and_return(player2)
          expect(player2).to receive(:next_player).exactly(2).times.and_return(player1)
          expect(player1).to receive(:accept_team?).with(players).exactly(5).times.and_return(false)
          expect(player2).to receive(:accept_team?).with(players).exactly(5).times.and_return(false)
          subject.play
          expect(subject.game_over?).to be_true
        end
      end
    end
  end

  describe '#game_over?' do
    context 'when the mission votes stalemate' do
      before do
        allow(player1).to receive(:pick_team).and_return(players)
        allow(player2).to receive(:pick_team).and_return(players)
        allow(player1).to receive(:accept_team?).with(players).and_return(false)
        allow(player2).to receive(:accept_team?).with(players).and_return(false)
        player1.previous_player= player2
      end

      it 'returns true' do
        subject.play
        expect(subject.game_over?).to be(true)
      end
    end

    context 'when the mission is played' do
      before do
        allow(player1).to receive(:pick_team).and_return(players)
        allow(player1).to receive(:accept_team?).with(players).and_return(true)
        allow(player2).to receive(:accept_team?).with(players).and_return(true)
      end
      it 'returns false' do
        subject.play
        expect(subject.game_over?).to be(false)
      end
    end
  end
end

