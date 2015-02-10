require 'spec_helper'

describe PlayerToBrainApi do
  let(:brain1)     { double('brain1', :api= => nil) }
  let(:brain2)     { double('brain2', :api= => nil) }
  let(:player1)    { Player.new(brain1, 'spy', nil)}
  let(:player2)    { Player.new(brain2, 'resistance', player1)}

  let(:api) {described_class.new(player1, brain1)}

  context '#initialize' do
    subject { api }
    it 'does not allow access to the player' do
      expect{subject.player}.to raise_error
      expect{subject.instance_variable_get('@player')}.to raise_error
      expect{subject.send(:player)}.to raise_error
      expect{subject.send(:instance_variable_get, '@player')}.to raise_error
    end
  end

  context '#open_eyes' do
    subject { api.open_eyes([player2]) }
    it 'passes an array of player names' do
      expect(brain1).to receive(:open_eyes).with([player2.name])
      subject
    end
  end

  context '#vote' do
    subject { api.vote([player1, player2]) }
    it 'passes an array of player names' do
      expect(brain1).to receive(:vote).with([player1.name, player2.name])
      subject
    end
  end

  context '#show_player_votes' do
    subject { api.show_player_votes({player1 => true, player2 => false}) }
    it 'passes an array of player names to votes' do
      expect(brain1).to receive(:show_player_votes).with({
        player1.name => true, player2.name => false})
      subject
    end
  end

  context '#show_mission_plays' do
    subject { api.show_mission_plays({true => [true], false => [false]}) }
    it 'passes an array of votes' do
      expect(brain1).to receive(:show_mission_plays).with([true, false])
      subject
    end
  end

  context '#pass_mission?' do
    subject { api.pass_mission?([player1, player2]) }
    it 'passes an array of player names' do
      expect(brain1).to receive(:pass_mission?).with([player1.name, player2.name])
      subject
    end
  end

  context '#pick_team' do
    subject { api.pick_team(2) }
    it 'passes the command to the brain' do
      expect(brain1).to receive(:pick_team).with(2)
      subject
    end
  end

  context '#player_names' do
    before { player1.previous_player = player2 }
    subject { api.player_names }
    it 'returns all player names' do
      expect(subject).to eql([player1.name, player2.name])
    end
  end

  context '#name' do
    subject{ api.name }
    it 'returns the name of the player' do
      expect(subject).to eql(player1.name)
    end
  end
end
