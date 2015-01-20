require 'spec_helper'

describe Game do
  let(:seed) {0}
  subject { described_class.new(brains, seed)}
  let(:brain_class_1) { double('Brain1') }
  let(:brain_class_2) { double('Brain2') }
  let(:brain1) { double('brain1') }
  let(:brain2) { double('brain2') }
  let(:brain3) { double('brain3') }
  let(:brain4) { double('brain4') }
  let(:player1) { Player.new(brain1, 'resistance')}
  let(:player2) { Player.new(brain2, 'spy')}
  let(:player3) { Player.new(brain3, 'spy')}
  let(:player4) { Player.new(brain4, 'resistance')}
  let(:brains) { [brain_class_1, brain_class_2, brain_class_1, brain_class_2]}

  describe '#initialize' do
    it 'creates new players' do
      expect(brain_class_1).to receive(:new).and_return(brain1, brain3)
      expect(brain_class_2).to receive(:new).and_return(brain2, brain4)
      expect(subject.players.first).to eq(player1)
      expect(subject.players.second).to eq(player2)
    end
  end

  describe '#play' do
    it 'reveals the spies to each other' do
      expect(brain_class_1).to receive(:new).and_return(brain1, brain3)
      expect(brain_class_2).to receive(:new).and_return(brain2, brain4)
      expect(subject.players.second).to receive(:open_eyes).with([player2, player3])
      expect(subject.players.third).to receive(:open_eyes).with([player2, player3])
      subject.play
    end
  end
end