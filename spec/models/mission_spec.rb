require 'spec_helper'

describe Mission do
  let(:player1) { double('player1', pass_mission?: nil)}
  let(:player2) { double('player2', pass_mission?: nil)}
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
    end
  end
end