require 'spec_helper'

describe Player do
  let(:brain1)  { double('brain1') }
  let(:brain2)  { double('brain2') }
  let(:player1) { Player.new(brain1, 'spy')}
  let(:player2) { Player.new(brain2, 'spy')}

  describe '#open_eyes' do
    subject { player1.open_eyes([player1, player2]) }
    it 'shows all other spies to the player' do
      expect(brain1).to receive(:open_eyes).with([player2])
      subject
    end
  end

  describe '#show_player_votes' do
    subject { player1.show_player_votes(player2 => true)}
    it 'passes a hash of players to votes to the brain' do
      expect(brain1).to receive(:show_player_votes).with({player2 => true})
      subject
    end
  end

  describe '#vote' do
    subject { player1.vote([player1, player2])}
    it 'passes the team to the brain' do
      expect(brain1).to receive(:vote).with([player1, player2])
      subject
    end
  end
end