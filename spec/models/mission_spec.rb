require 'spec_helper'

describe Mission do
  let(:brain1) { double('brain1', show_player_votes: nil)}
  let(:brain2) { double('brain2', show_player_votes: nil)}
  let(:player1) { Player.new(brain1, nil)}
  let(:player2) { Player.new(brain2, nil)}
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
      it 'asks the players if they want to pass the mission' do
        expect(player1).to receive(:vote).with(players).and_return(true)
        expect(player2).to receive(:vote).with(players).and_return(true)
        expect(player1).to receive(:pass_mission?)
        expect(player2).to receive(:pass_mission?)
        subject.play
      end
    end

    context 'the vote fails' do
      it 'asks the next leader to pick a team' do
        expect(player2).to receive(:pick_team).and_return(players)
        expect(player1).to receive(:next).and_return(player2)
        expect(player1).to receive(:vote).with(players).and_return(false, true)
        expect(player2).to receive(:vote).with(players).and_return(false, true)
        subject.play
      end

      context 'the vote fails 5 times' do
        it 'the game is over' do
          expect(player2).to receive(:pick_team).exactly(2).times.and_return(players)
          expect(player1).to receive(:next).exactly(2).times.and_return(player2)
          expect(player2).to receive(:next).exactly(2).times.and_return(player1)
          expect(player1).to receive(:vote).with(players).exactly(5).times.and_return(false)
          expect(player2).to receive(:vote).with(players).exactly(5).times.and_return(false)
          subject.play
          expect(subject.game_over?).to be_true
        end
      end
    end
  end
end