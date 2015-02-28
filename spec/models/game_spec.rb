require 'spec_helper'

describe Game do
  let(:seed) {0}
  let(:game) { described_class.new(brains, seed)}
  let(:brain_class1) { double('BrainClass1') }
  let(:brain_class2) { double('BrainClass2') }
  let(:brain1) { double('brain1', :api= => nil) }
  let(:brain2) { double('brain2', :api= => nil) }
  let(:brain3) { double('brain3', :api= => nil) }
  let(:brain4) { double('brain4', :api= => nil) }
  let(:player1) { Player.new(game, brain1, 'resistance', nil)}
  let(:player2) { Player.new(game, brain2, 'spy', player1)}
  let(:player3) { Player.new(game, brain3, 'spy', player2)}
  let(:player4) { Player.new(game, brain4, 'resistance', player3)}
  let(:brains) { [brain_class1, brain_class2, brain_class1, brain_class2]}

  subject { game }

  describe '#initialize' do
    before do
      allow(brain_class1).to receive(:new_for).and_return(brain1, brain3)
      allow(brain_class2).to receive(:new_for).and_return(brain2, brain4)
    end
    it 'creates new players' do
      expect(brain_class1).to receive(:new_for).and_return(brain1, brain3)
      expect(brain_class2).to receive(:new_for).and_return(brain2, brain4)
      expect(subject.players.first).to eq(player1)
      expect(subject.players.second).to eq(player2)
    end

    it 'sets the players up in order' do
      subject
      expect(subject.players.first.next_player).to eql(subject.players.second)
      expect(subject.players.second.next_player).to eql(subject.players.third)
      expect(subject.players.third.next_player).to eql(subject.players.fourth)
      expect(subject.players.fourth.next_player).to eql(subject.players.first)
      expect(subject.players.first.previous_player).to eql(subject.players.fourth)
      expect(subject.players.second.previous_player).to eql(subject.players.first)
      expect(subject.players.third.previous_player).to eql(subject.players.second)
      expect(subject.players.fourth.previous_player).to eql(subject.players.third)
    end
  end

  describe '#play' do
    before do
      allow(brain_class1).to receive(:new_for).and_return(brain1, brain3)
      allow(brain_class2).to receive(:new_for).and_return(brain2, brain4)
    end
    let(:mission) { double('Mission', winning_team: 'spy', play: nil,
      leader: double(next_player: player2), game_over?: false)}

    before do
      allow(subject.players.second).to receive(:open_eyes).with([player2, player3])
      allow(subject.players.third).to receive(:open_eyes).with([player2, player3])
      allow(Mission).to receive(:new).exactly(3).times.and_return(mission)
    end

    it 'reveals the spies to each other' do
      expect(subject.players.second).to receive(:open_eyes).with([player2, player3])
      expect(subject.players.third).to receive(:open_eyes).with([player2, player3])
      subject.play
    end

    it 'creates new missions until one team wins 3 times' do
      expect(Mission).to receive(:new).exactly(3).times.and_return(mission)
      subject.play
      expect(subject.winning_team).to eql('spy')
    end

    it 'creates new missions with the correct leader' do
      expect(mission).to receive(:leader).and_return(double(next_player: player2), double(next_player: player3))
      expect(Mission).to receive(:new).ordered.with(subject, player1, anything, 1).and_return(mission)
      expect(Mission).to receive(:new).ordered.with(subject, player2, anything, 2).and_return(mission)
      expect(Mission).to receive(:new).ordered.with(subject, player3, anything, 3).and_return(mission)
      subject.play
    end

    context 'when a mission stalemates' do
      let(:mission) { double('Mission', game_over?: true, play: nil, winning_team: nil)}
      it 'ends the game' do
        expect(Mission).to receive(:new).once.and_return(mission)
        subject.play
        expect(subject.winning_team).to eql('spy')
      end
    end
  end

  describe '#current_mission' do
    subject { game.current_mission }
    let(:brains) { [brain_class1, brain_class2, brain_class1, brain_class2, brain_class2] }
    let(:mission) { double('Mission').as_null_object }
    let(:player5) { Player.new(game, brain4, 'resistance', player3) }
    let(:brain_class1) { double('BrainClass1').as_null_object }
    let(:brain_class2) { double('BrainClass2').as_null_object }
    it 'returns the mission currently being played' do
      expect(Mission).to receive(:new).and_return(mission)
      game.play
      expect(subject).to eql(mission)
    end
  end

  describe '#mission_winners' do
    before do
      allow(brain_class1).to receive(:new_for).and_return(brain1, brain3)
      allow(brain_class2).to receive(:new_for).and_return(brain2, brain4)
    end
    subject { game.mission_winners }
    context 'with no missions played' do
      it 'returns an empty array' do
        expect(subject).to eql([])
      end
    end
    context 'with missions played' do
      def mission(team)
        double('mission', winning_team: team, play: nil, leader: player1, game_over?: false)
      end
      let(:spy_mission)        { mission('spy') }
      let(:resistance_mission) { mission('resistance') }
      it 'returns the name of the winning teams, in order' do
        expect(Mission).to receive(:new).and_return(spy_mission, resistance_mission, spy_mission, spy_mission)
        allow(brain2).to receive(:open_eyes)
        allow(brain3).to receive(:open_eyes)
        game.play
        expect(subject).to match_array(['spy', 'resistance', 'spy', 'spy'])
      end
    end
  end
end
