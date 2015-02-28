require 'spec_helper'

describe PlayerToBrainApi do
  let(:brain1)     { double('brain1', :api= => nil) }
  let(:brain2)     { double('brain2', :api= => nil) }
  let(:player1)    { Player.new(game, brain1, 'spy', nil)}
  let(:player2)    { Player.new(game, brain2, 'resistance', player1)}
  let(:mission)    { double('Mission', mission_number: 1, leader: player2, fails_needed: 1, team: [player1, player2])}
  let(:game)       { double('Game', mission_winners: ['spy', 'resistance'])}
  let(:api) {described_class.new(player1, brain1)}
  before do
    allow(player1).to receive(:current_mission).and_return(mission)
    allow(player1).to receive(:game).and_return(game)
  end

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

  context '#accept_team?' do
    subject { api.accept_team?([player1, player2]) }
    it 'passes an array of player names' do
      expect(brain1).to receive(:accept_team?).with([player1.name, player2.name])
      subject
    end
  end

  context '#show_team_votes' do
    subject { api.show_team_votes({player1 => true, player2 => false}) }
    it 'passes an array of player names to votes' do
      expect(brain1).to receive(:show_team_votes).with({
        player1.name => true, player2.name => false})
      subject
    end
  end

  context '#show_mission_votes' do
    subject { api.show_mission_votes({true => [true], false => [false]}) }
    it 'passes an array of votes' do
      expect(brain1).to receive(:show_mission_votes).with([true, false])
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
    before { player1.previous_player = player2}
    it 'passes the command to the brain' do
      expect(brain1).to receive(:pick_team).with(2).and_return([player1.name, player2.name])
      subject
    end
    context 'when the brain picks too few players' do
      it 'fails' do
        expect(brain1).to receive(:pick_team).with(2).and_return([player1.name])
        expect{subject}.to raise_error
      end
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

  context '#current_mission_number' do
    subject { api.current_mission_number }
    it 'returns the current mission number' do
      expect(subject).to eql(1)
    end
  end

  context '#current_team' do
    subject { api.current_team }
    it 'returns the names of the current team' do
      expect(subject).to eql([player1.name, player2.name])
    end
  end

  context '#current_leader' do
    subject { api.current_leader }
    it 'returns the names of the current leader' do
      expect(subject).to eql(player2.name)
    end
  end

  context '#current_number_of_fails_needed' do
    subject { api.current_number_of_fails_needed }
    it 'returns the current number of fails needed' do
      expect(subject).to eql(1)
    end
  end

  context '#mission_winners' do
    subject { api.mission_winners }
    it 'returns the current number of fails needed' do
      expect(subject).to eql(['spy', 'resistance'])
    end
  end
end
