require 'spec_helper'

describe Event do
  class SubEvent < Event
    def initialize(player, other_player)
      @player, @other_player = player, other_player
    end
    def to_s; 'SubEvent'; end
  end
  describe '#as_json' do
    let(:brain1)     { double('brain1', :api= => nil) }
    let(:brain2)     { double('brain2', :api= => nil) }
    let(:game)       { double('Game', current_mission: nil) }
    let(:player1) { Player.new(game, brain1, 'spy', nil) }
    let(:player2) { Player.new(game, brain2, 'resistance', player1) }
    before { player1.previous_player = player2 }

    let(:event) { SubEvent.new(player1, player2) }
    subject { event.to_json }
    it 'serializes all instance variables' do
      # binding.pry
      expect(JSON.parse(subject)).to eql({ 'type' => 'SubEvent',
        'to_s' => 'SubEvent', 'player' => player1.as_json.stringify_keys,
        'other_player' => player2.as_json.stringify_keys})
    end
  end
end
