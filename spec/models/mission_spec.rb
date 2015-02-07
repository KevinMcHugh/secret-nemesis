require 'spec_helper'

describe Mission do
  let(:brain1) { double('brain1', show_player_votes: nil,
    pass_mission?: false, show_mission_plays: nil)}
  let(:brain2) { double('brain2', show_player_votes: nil,
    pass_mission?: false, show_mission_plays: nil)}
  let(:player1) { Player.new(brain1, 'spy', nil)}
  let(:player2) { Player.new(brain2, 'resistance', player1)}
  let(:players) { [player1, player2]}
  subject { described_class.new(player1, players) }
  describe '#initialize' do
    it 'accepts a leader and players' do
      expect(subject.leader).to eql(player1)
      expect(subject.players).to eql(players)
    end
  end

  describe '#play' do
    before do
      allow(player1).to receive(:pick_team).and_return(players)
      allow(player1).to receive(:vote).with(players).and_return(true)
      allow(player2).to receive(:vote).with(players).and_return(true)
      allow(player1).to receive(:show_mission_plays)
      allow(player2).to receive(:show_mission_plays)
    end

    it 'asks the leader to pick a team' do
      expect(player1).to receive(:pick_team)
      subject.play
    end

    it 'puts the picked team to a vote' do
      expect(player1).to receive(:vote).with(players)
      expect(player2).to receive(:vote).with(players)
      subject.play
    end

    it 'reveals votes to all players' do
      expect(player1).to receive(:show_player_votes).with({player1 => true, player2 => true})
      expect(player2).to receive(:show_player_votes).with({player1 => true, player2 => true})
      subject.play
    end

    context 'the vote passes' do
      before do
        allow(player1).to receive(:vote).with(players).and_return(true)
        allow(player2).to receive(:vote).with(players).and_return(true)
      end

      it 'asks the spies if they want to pass the mission' do
        expect(player1).to receive(:pass_mission?).with(players)
        expect(player2).not_to receive(:pass_mission?)
        subject.play
      end

      it 'reveals the mission plays' do
        expect(player1).to receive(:show_mission_plays).with({true => [true], false => [false]})
        expect(player2).to receive(:show_mission_plays).with({true => [true], false => [false]})
        expect(player1).to receive(:pass_mission?).and_return(false)
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
        it 'sets the winning team to spy' do
          expect(player1).to receive(:pass_mission?).and_return(false)
          subject.play
          expect(subject.winning_team).to eq('spy')
        end
      end
    end

    context 'the vote fails' do
      it 'asks the next leader to pick a team' do
        expect(player2).to receive(:pick_team).and_return(players)
        expect(player1).to receive(:next_player).and_return(player2)
        expect(player1).to receive(:vote).with(players).and_return(false)
        expect(player2).to receive(:vote).with(players).and_return(false)
        subject.play
      end

      context 'the vote fails 5 times' do
        it 'the game is over' do
          expect(player2).to receive(:pick_team).exactly(2).times.and_return(players)
          expect(player1).to receive(:next_player).exactly(2).times.and_return(player2)
          expect(player2).to receive(:next_player).exactly(2).times.and_return(player1)
          expect(player1).to receive(:vote).with(players).exactly(5).times.and_return(false)
          expect(player2).to receive(:vote).with(players).exactly(5).times.and_return(false)
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
        allow(player1).to receive(:vote).with(players).and_return(false)
        allow(player2).to receive(:vote).with(players).and_return(false)
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
        allow(player1).to receive(:vote).with(players).and_return(true)
        allow(player2).to receive(:vote).with(players).and_return(true)
      end
      it 'returns false' do
        subject.play
        expect(subject.game_over?).to be(false)
      end
    end
  end
end

