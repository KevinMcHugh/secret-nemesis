require 'spec_helper'

describe Game do
  describe '#initialize' do
    let(:seed) {0}
    subject { described_class.new([brain_class_1, brain_class_2], seed)}
    let(:brain_class_1) { double('Brain1') }
    let(:brain_class_2) { double('Brain2') }
    let(:brain1) { double('brain1') }
    let(:brain2) { double('brain2') }
    let(:player1) { Player.new(brain1, 'spy')}
    let(:player2) { Player.new(brain2, 'resistance')}
    it 'creates new players' do
      expect(brain_class_1).to receive(:new).and_return(brain1)
      expect(brain_class_2).to receive(:new).and_return(brain2)
      expect(subject.players.first).to eq(player1)
      expect(subject.players.second).to eq(player2)
    end
  end
end