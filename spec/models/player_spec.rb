require 'spec_helper'

describe Player do
  let(:brain1)  { double('brain1') }
  let(:brain2)  { double('brain2') }
  let(:player1) { Player.new(brain1, 'spy')}
  let(:player2) { Player.new(brain2, 'resistance')}

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

  describe '#spy?' do
    subject { player.spy?}
    context 'a spy' do
      let(:player) { player1 }
      it 'returns true' do
        expect(subject).to be(true)
      end
    end
    context 'a rebel' do
      let(:player) { player2 }
      it 'returns false' do
        expect(subject).to be(false)
      end
    end
  end

  describe '#pick_team' do
    subject { player1.pick_team }
    it 'passes the request to the brain' do
      expect(brain1).to receive(:pick_team)
      subject
    end
  end

  describe '#pass_mission?' do
    subject { player1.pass_mission? }
    it 'passes the request to the brain' do
      expect(brain1).to receive(:pass_mission?)
      subject
    end
  end
end