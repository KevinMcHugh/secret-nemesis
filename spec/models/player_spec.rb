require 'spec_helper'

describe Player do

  describe '#open_eyes' do
    let(:brain1)  { double('brain1') }
    let(:brain2)  { double('brain2') }
    let(:player1) { Player.new(brain1, 'spy')}
    let(:player2) { Player.new(brain2, 'spy')}
    subject { player1.open_eyes([player1, player2]) }
    it 'shows all other spies to the player' do
      expect(brain1).to receive(:open_eyes).with([player2])
      subject
    end
  end
end